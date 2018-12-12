//
//  StickerEditController.cpp
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#include "StickerEditController.h"
#include "GestureRecognizerUtils.h"

using namespace cocos2d;

StickerEditController* StickerEditController::create() {
    StickerEditController* stickerVC = new (std::nothrow) StickerEditController();
    if (stickerVC && stickerVC->init()) {
        return stickerVC;
    }
    
    return nullptr;
}

bool StickerEditController::init() {
    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();
    
    _touchStickerCount = 0;
    _frontZOrder = 0;
    _isPinching = false;
    _sticker = nullptr;
    _recyclingArea = Node::create();
    _recyclingArea->setAnchorPoint(Vec2(0.5f, 0.5f));
    _recyclingArea->setContentSize(Size(visibleSize.width*0.125f, visibleSize.width*0.125f));
    _recyclingArea->setPosition(Vec2(visibleSize.width*0.5f + origin.x, visibleSize.height*0.92f + origin.y));
    this->addChild(_recyclingArea, 1000);
//    auto drawRectDebuger = DrawNode::create();
//    drawRectDebuger->drawSolidRect(Vec2::ZERO, Vec2(_recyclingArea->getContentSize()), Color4F::RED);
//    _recyclingArea->addChild(drawRectDebuger);
    
    _recyclingBin = Sprite::create("recyclingbin.png");
    _recyclingBin->setScale(0.5f);
    _recyclingBin->setPosition(Vec2(_recyclingArea->getContentSize().width*0.5f, _recyclingArea->getContentSize().width*0.5f));
    _recyclingBin->setVisible(false);
    _recyclingArea->addChild(_recyclingBin);

    onEditStickerBegan = nullptr;
    onEditStickerEnded = nullptr;
//    auto listener = EventListenerTouchOneByOne::create();
//    listener->onTouchBegan = CC_CALLBACK_2(StickerEditViewController::onTouchBegan, this);
//    listener->onTouchMoved = CC_CALLBACK_2(StickerEditViewController::onTouchMoved, this);
//    listener->onTouchEnded = CC_CALLBACK_2(StickerEditViewController::onTouchEnded, this);
//
//    Director::getInstance()->getEventDispatcher()->addEventListenerWithSceneGraphPriority(listener, this);
    
    PinchGestureRecognizer* pinchGesture = PinchGestureRecognizer::create();
    pinchGesture->onPinch = CC_CALLBACK_1(StickerEditController::onPinch, this);
    pinchGesture->setContentSize(Director::getInstance()->getVisibleSize());
    this->addChild(pinchGesture, 0);
    
    PanGestureRecognizer* panGesture = PanGestureRecognizer::create(1);
    panGesture->onPan = CC_CALLBACK_1(StickerEditController::onPan, this);
    panGesture->setContentSize(Director::getInstance()->getVisibleSize());
    this->addChild(panGesture, 0);
//    panGesture->setDebugMode(true);
    
    return true;
}


void StickerEditController::onPinch(PinchGestureRecognizer* recognizer)
{
    log(">>>> Pinch");
    auto stato = recognizer->getStatus();
    auto location = recognizer->getGestureLocation();
    
    static bool filterTouch { true };
    if (stato == GestureStatus::BEGAN)
    {
        _isPinching = true;
        //CCLOG("Pinch Began");
        if (_sticker)
            filterTouch = not nodeContainsThePoint(_sticker, location);
        
        if (not filterTouch) {
            _touchStickerCount++;
            if (this->onTouchStickerBegan) {
                this->onTouchStickerBegan();
            }
        }
    }
    else if (stato == GestureStatus::CHANGED)
    {
        auto factor = recognizer->getPinchFactor();
        auto angle  = recognizer->getPinchRotation();
        auto trasl  = recognizer->getPinchTraslation();
        //CCLOG("Pinch factor: %f", factor);
        //CCLOG("Traslation: %f, %f", trasl.x, trasl.y);
        if (_sticker and not filterTouch)
        {
            _sticker->setScale   (_sticker->getScale()    * factor);
            _sticker->setRotation(_sticker->getRotation() + angle);
            _sticker->setPosition(_sticker->getPosition() + trasl);
        }
    }
    else
    {
        filterTouch = true;
        _isPinching = false;
        _touchStickerCount--;
        if (_touchStickerCount < 0) {
            _touchStickerCount = 0;
        }
        if (_touchStickerCount == 0) {
            if (this->onEditStickerEnded) {
                this->onEditStickerEnded();
            }
        }
    }
}

void StickerEditController::onPan(PanGestureRecognizer* recognizer) {
    auto stato = recognizer->getStatus();
    auto location = recognizer->getGestureLocation();
    
    static Vec2 touchBeganLocation;
    static bool isTouchBeganInside { false };
    static bool isStickerScaling = false;
    static bool isChanged = false;
    static float lastStickerScale = -1.0f;
    
    if (stato == GestureStatus::BEGAN) {
        isStickerScaling = false;
        touchBeganLocation = location;

        auto childs = this->getChildren();
        if (!childs.empty()) {
            Node::sortDecsNodes(childs);
            for (auto child : childs) {
                if (((child->getTag() & StickerType::STATIC_STICKER) == StickerType::STATIC_STICKER) && child->isVisible()) {
                    auto zOrder = child->getLocalZOrder();
                    if (_frontZOrder < zOrder) {
                        _frontZOrder = zOrder;
                    }
                    Sprite* sticker = dynamic_cast<Sprite *>(child);
                    if (sticker && sticker->getBoundingBox().containsPoint(location)) {
                        _sticker = child;
                        isTouchBeganInside = true;
                        if (_sticker->getLocalZOrder() != _frontZOrder) {
                            this->reorderChild(_sticker, ++_frontZOrder);
                        }
                        if (this->onTouchStickerBegan) {
                            this->onTouchStickerBegan();
                        }
                        return;
                    }
                }
            }
        }
        isTouchBeganInside = false;
    }
    else if (stato == GestureStatus::CHANGED)
    {
        if (isTouchBeganInside && !_isPinching && touchBeganLocation != location) {
            auto location = recognizer->getGestureLocation();
            if (_sticker) {
                if (!isChanged) {
                    _touchStickerCount++;
                    if (this->onEditStickerBegan) {
                        this->onEditStickerBegan();
                    }
                }
                isChanged = true;
                _sticker->setPosition(_sticker->getPosition() + recognizer->getTraslation());
                _recyclingBin->setVisible(true);
                
                if (_recyclingArea->getBoundingBox().containsPoint(location)) {
                    if (!isStickerScaling) {
                        isStickerScaling = true;
                        lastStickerScale = _sticker->getScale()*0.5f;
                        _recyclingBin->runAction(ScaleTo::create(0.05f, 1.0f));
                        auto scaleAction = ScaleTo::create(0.05f, lastStickerScale);
//                        auto callFunc = CallFunc::create([&](){
//                            isStickerScaling = true;
//                        });
//                        auto seqAction = Sequence::create(scaleAction, callFunc, NULL);
                        _sticker->runAction(scaleAction);
                        _sticker->setOpacity(255.0f/2.0f);
                    }
                } else {
                    if (isStickerScaling) {
                        isStickerScaling = false;
                        lastStickerScale = lastStickerScale*2.0f;
                        _recyclingBin->runAction(ScaleTo::create(0.05f, 0.5f));
                        auto scaleAction = ScaleTo::create(0.05f, lastStickerScale);
//                        auto callFunc = CallFunc::create([&](){
//
//                        });
//                        auto seqAction = Sequence::create(scaleAction, callFunc, NULL);
                        _sticker->runAction(scaleAction);
                        _sticker->setOpacity(255.0f);
                        lastStickerScale = _sticker->getScale();
                    }
                }
            }
        }
    } else {
        if (isTouchBeganInside) {
            if (touchBeganLocation == location) {
                this->tapStickerAnimation();
                isTouchBeganInside = false;
            }
            
            _touchStickerCount--;
            if (_touchStickerCount < 0) {
                _touchStickerCount = 0;
            }
            if (_touchStickerCount == 0) {
                if (this->onEditStickerEnded) {
                    this->onEditStickerEnded();
                }
            }
        }
        
        if (_recyclingArea->getBoundingBox().containsPoint(location)) {
            auto scale0Action = ScaleTo::create(0.1f, 0.01f);
            auto removeAction = RemoveSelf::create();
            auto seqAction = Sequence::create(scale0Action, removeAction, NULL);
            _sticker->runAction(seqAction);
            _sticker = nullptr;
        }
        
        _recyclingBin->setVisible(false);
        _recyclingBin->setScale(0.5f);
        isChanged = false;
    }
}

void StickerEditController::tapStickerAnimation() {
    auto scaleInAction = ScaleTo::create(0.05f, _sticker->getScale()*0.8f);
    auto scaleOutAction = ScaleTo::create(0.05f, _sticker->getScale());
    auto seqAction = Sequence::create(scaleInAction, scaleOutAction, nullptr);
    _sticker->runAction(seqAction);
}

cocos2d::Node* StickerEditController::getSticker() {
    return _sticker;
}

void StickerEditController::setSticker(cocos2d::Node* sticker) {
    _sticker = sticker;
}

void StickerEditController::setEnable(bool enable) {
    _isEnable = enable;
}

bool StickerEditController::isEnable() {
    return _isEnable;
}

int StickerEditController::getFrontZOrder() {
    return _frontZOrder;
}

void StickerEditController::addSticker(cocos2d::Sprite* sticker, bool isAnimation) {
    if (sticker) {
        this->addChild(sticker, ++_frontZOrder);
        if (isAnimation) {
            auto scaleOutAction = ScaleTo::create(0.25f, sticker->getScale()*1.2f);
            auto scaleInAction = ScaleTo::create(0.075f, sticker->getScale());
            sticker->setScale(0.01f);
            
            auto seqAction = Sequence::create(scaleOutAction, scaleInAction, nullptr);
            sticker->runAction(seqAction);
        }
    }
}

void StickerEditController::removeAllSticker() {
    auto childs = this->getChildren();
    if (!childs.empty()) {
        for (auto child : childs) {
            if (child->getTag() == StickerType::STATIC_STICKER) {
                child->removeFromParentAndCleanup(true);
            }
        }
    }
    _sticker = nullptr;
}

void StickerEditController::removeSticker(cocos2d::Node* sticker, bool isCleanup) {
    if (_sticker == sticker) {
        _sticker = nullptr;
    }
    sticker->removeFromParentAndCleanup(isCleanup);
}
