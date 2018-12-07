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
    
    _frontZOrder = 0;
    _isPinching = false;
    _sticker = nullptr;
    _recyclingBin = Sprite::create("recyclingbin.png");
    _recyclingBin->setScale(0.5f);
    _recyclingBin->setPosition(Vec2(visibleSize.width*0.5f + origin.x, visibleSize.height*0.92f + origin.y));
    _recyclingBin->setVisible(false);
    this->addChild(_recyclingBin, 100);
    
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
    else if (stato == GestureStatus::RECOGNIZED)
    {
        filterTouch = true;
        _isPinching = false;
    }
}

void StickerEditController::onPan(PanGestureRecognizer* recognizer) {
    auto stato = recognizer->getStatus();
    auto location = recognizer->getGestureLocation();
    
    static Vec2 touchBeganLocation;
    static bool isTouchBeganInside { false };
    static float stickerScale = 1.0f;
    static bool isStickerScaling = false;
    
    if (stato == GestureStatus::BEGAN) {
        isStickerScaling = false;
        touchBeganLocation = location;

        auto childs = this->getChildren();
        if (!childs.empty()) {
            Node::sortDecsNodes(childs);
            for (auto child : childs) {
                if (child->getTag() == StickerType::STATIC_STICKER && child->isVisible()) {
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
                _sticker->setPosition(_sticker->getPosition() + recognizer->getTraslation());
                _recyclingBin->setVisible(true);
//                auto sprite = dynamic_cast<Sprite *>(_sticker);
                if (_recyclingBin->getBoundingBox().containsPoint(location)) {
                    if (!isStickerScaling) {
                        _recyclingBin->runAction(ScaleTo::create(0.05f, 1.0f));
                        stickerScale = _sticker->getScale()*0.5f;
                        _sticker->runAction(ScaleTo::create(0.05f, stickerScale));
                        _sticker->setOpacity(255.0f/2.0f);
                    }
                    isStickerScaling = true;
                } else {
                    if (isStickerScaling) {
                        _recyclingBin->runAction(ScaleTo::create(0.05f, 0.5f));
                        _sticker->runAction(ScaleTo::create(0.05f, _sticker->getScale()*2.0f));
                        _sticker->setOpacity(255.0f);
                        isStickerScaling = false;
                    }
                }
            }
        }
    } else if (stato == GestureStatus::FAILED) {
        log(">>>> end");
        if (isTouchBeganInside && touchBeganLocation == location) {
            this->tapStickerAnimation();
            isTouchBeganInside = false;
        }
    } else if (stato == GestureStatus::RECOGNIZED) {
        if (isTouchBeganInside && touchBeganLocation == location) {
            this->tapStickerAnimation();
            isTouchBeganInside = false;
        }
        _recyclingBin->setVisible(false);
        _recyclingBin->setScale(0.5f);
        
        if (_recyclingBin->getBoundingBox().containsPoint(location)) {
            auto scale0Action = ScaleTo::create(0.1f, 0.01f);
            auto removeAction = RemoveSelf::create();
            auto seqAction = Sequence::create(scale0Action, removeAction, NULL);
            _sticker->runAction(seqAction);
            _sticker = nullptr;
        }
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

void StickerEditController::addSticker(cocos2d::Sprite* sticker) {
    if (sticker) {
        this->addChild(sticker, ++_frontZOrder);
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
}
//
//bool StickerEditViewController::onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event) {
//    if (!_stickersParent) {
//        return false;
//    }
//
//    auto childs = _stickersParent->getChildren();
//    if (!childs.empty()) {
//        Node::sortDecsNodes(childs);
//        auto point = touch->getLocation();
//        for (auto child : childs) {
//            if (child->getTag() == StickerType::STATIC_STICKER && child->isVisible()) {
//                auto zOrder = child->getLocalZOrder();
//                if (_frontZOrder < zOrder) {
//                    _frontZOrder = zOrder;
//                }
//                Sprite* sticker = dynamic_cast<Sprite *>(child);
//                if (sticker && sticker->getBoundingBox().containsPoint(point)) {
//                    _sticker = child;
//                    _stickersParent->reorderChild(_sticker, 1000);
//                    this->drawStickerRect();
//                    return true;
//                }
//            }
//        }
//    }
//
//    childs = this->getChildren();
//    if (!childs.empty()) {
//        auto point = touch->getLocation();
//        for (auto child : childs) {
//            Sprite* sticker = dynamic_cast<Sprite *>(child);
//            if (sticker && child->isVisible() && sticker->getBoundingBox().containsPoint(point)) {
//                if (child->getTag() == StickerEditType::CLOSE_EDIT_BUTTON) {
//                    _isTouchCloseButton = true;
//                    return true;
//                } else if (child->getTag() == StickerEditType::SCALE_STICKER_BUTTON) {
//                    _isTouchScaleButton = true;
//                    return true;
//                }
//            }
//        }
//    }
//
//    _isTouchScaleButton = false;
//    _isTouchCloseButton = false;
//    if (_sticker) {
//        if (_frontZOrder != _sticker->getLocalZOrder()) {
//            _frontZOrder++;
//            _stickersParent->reorderChild(_sticker, _frontZOrder);
//        }
//
//        this->clearEditView();
//    }
//    return false;
//}
//
//bool StickerEditViewController::onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event) {
//    if (!_isTouchCloseButton) {
//        auto offsetVec2 = touch->getDelta();
//        if (!_isTouchScaleButton) {
//            if (_sticker) {
//                auto stickerPosition = _sticker->getPosition() + offsetVec2;
//                _sticker->setPosition(stickerPosition);
//                this->drawStickerRect();
//            }
//        } else {
//
//        }
//    }
//
//    return true;
//}
//
//bool StickerEditViewController::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event) {
//
//    if (touch->getStartLocation() == touch->getLocation()) {
//        if (_isTouchCloseButton) {
//            auto scale0Action = ScaleTo::create(0.1f, 0.01f);
//            auto removeAction = RemoveSelf::create();
//            auto seqAction = Sequence::create(scale0Action, removeAction, NULL);
//            _sticker->runAction(seqAction);
//            this->clearEditView();
//        } else if (_sticker) {
//            log(">>>> %d", _sticker->getLocalZOrder());
//            auto scaleInAction = ScaleTo::create(0.075f, 0.8f);
//            auto scaleOutAction = ScaleTo::create(0.075f, 1.0f);
//            auto seqAction = Sequence::create(scaleInAction, scaleOutAction, NULL);
//            _sticker->runAction(seqAction);
//        }
//
//    }
////        _sticker = nullptr;
//    _isTouchScaleButton = false;
//    _isTouchCloseButton = false;
//    return true;
//}
//
//
//void StickerEditViewController::drawStickerRect() {
//    _drawNode->clear();
//
//    auto stickerPosition = _sticker->getPosition();
//    auto contentSize = _sticker->getContentSize();
//    auto anchorPoint = _sticker->getAnchorPoint();
//    auto halfSize = Size(contentSize.width * anchorPoint.x, contentSize.height * anchorPoint.y);
//    auto topleft = Vec2(stickerPosition.x - halfSize.width, stickerPosition.y + contentSize.height - halfSize.height) + Vec2(-5, 5);
//    auto bottomright = Vec2(stickerPosition.x + contentSize.width - halfSize.width, stickerPosition.y - halfSize.height) + Vec2(5, -5);
//    _drawNode->drawRect(topleft, bottomright, Color4F(1.0f, 1.0f ,1.0f , 0.5f));
//
//    _editStickerCloseButton->setPosition(topleft);
//    _scaleStickerButton->setPosition(bottomright);
//    _editStickerCloseButton->setVisible(true);
//    _scaleStickerButton->setVisible(true);
//}
//
//void StickerEditViewController::clearEditView() {
//    _sticker = nullptr;
//    _drawNode->clear();
//    _editStickerCloseButton->setVisible(false);
//    _scaleStickerButton->setVisible(false);
//}
