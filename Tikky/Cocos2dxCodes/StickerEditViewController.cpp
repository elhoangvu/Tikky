//
//  StickerEditViewController.cpp
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#include "StickerEditViewController.h"

using namespace cocos2d;

StickerEditViewController* StickerEditViewController::create(cocos2d::Node* stickersParent, cocos2d::Node* sticker) {
    StickerEditViewController* stickerVC = new (std::nothrow) StickerEditViewController();
    if (stickerVC && stickerVC->init(stickersParent, sticker)) {
        return stickerVC;
    }
    
    return nullptr;
}

bool StickerEditViewController::init(Node* stickersParent, Node* sticker) {
    _frontZOrder = 0;
    _isTouchCloseButton = false;
    _isTouchScaleButton = false;
    _stickersParent = stickersParent;
    _sticker = sticker;
    _drawNode = DrawNode::create();
    _drawNode->setLineWidth(4.0f);
    this->addChild(_drawNode, 10000);
    
    _editStickerCloseButton = Sprite::create("close50.png");
    _scaleStickerButton = Sprite::create("scale50.png");
    _editStickerCloseButton->setVisible(false);
    _scaleStickerButton->setVisible(false);
    
    _editStickerCloseButton->setTag(StickerEditType::CLOSE_EDIT_BUTTON);
    _scaleStickerButton->setTag(StickerEditType::SCALE_STICKER_BUTTON);
    
    this->addChild(_editStickerCloseButton, 100000);
    this->addChild(_scaleStickerButton, 100000);
    
    auto listener = EventListenerTouchOneByOne::create();
    listener->onTouchBegan = CC_CALLBACK_2(StickerEditViewController::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(StickerEditViewController::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(StickerEditViewController::onTouchEnded, this);
    
    Director::getInstance()->getEventDispatcher()->addEventListenerWithSceneGraphPriority(listener, this);
    
    return true;
}

cocos2d::Node* StickerEditViewController::getSticker() {
    return _sticker;
}

void StickerEditViewController::setSticker(cocos2d::Node* sticker) {
    _sticker = sticker;
}

void StickerEditViewController::setEnable(bool enable) {
    _isEnable = enable;
}

bool StickerEditViewController::isEnable() {
    return _isEnable;
}

int StickerEditViewController::getFrontZOrder() {
    return _frontZOrder;
}

bool StickerEditViewController::onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event) {
    if (!_stickersParent) {
        return false;
    }
    
    auto childs = _stickersParent->getChildren();
    if (!childs.empty()) {
        Node::sortDecsNodes(childs);
        auto point = touch->getLocation();
        for (auto child : childs) {
            if (child->getTag() == StickerType::STATIC_STICKER && child->isVisible()) {
                auto zOrder = child->getLocalZOrder();
                if (_frontZOrder < zOrder) {
                    _frontZOrder = zOrder;
                }
                Sprite* sticker = dynamic_cast<Sprite *>(child);
                if (sticker && sticker->getBoundingBox().containsPoint(point)) {
                    _sticker = child;
                    _stickersParent->reorderChild(_sticker, 1000);
                    this->drawStickerRect();
                    return true;
                }
            }
        }
    }
    
    childs = this->getChildren();
    if (!childs.empty()) {
        auto point = touch->getLocation();
        for (auto child : childs) {
            Sprite* sticker = dynamic_cast<Sprite *>(child);
            if (sticker && child->isVisible() && sticker->getBoundingBox().containsPoint(point)) {
                if (child->getTag() == StickerEditType::CLOSE_EDIT_BUTTON) {
                    _isTouchCloseButton = true;
                    return true;
                } else if (child->getTag() == StickerEditType::SCALE_STICKER_BUTTON) {
                    _isTouchScaleButton = true;
                    return true;
                }
            }
        }
    }
    
    _isTouchScaleButton = false;
    _isTouchCloseButton = false;
    if (_sticker) {
        if (_frontZOrder != _sticker->getLocalZOrder()) {
            _frontZOrder++;
            _stickersParent->reorderChild(_sticker, _frontZOrder);
        }

        this->clearEditView();
    }
    return false;
}

bool StickerEditViewController::onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event) {
    if (!_isTouchCloseButton) {
        auto offsetVec2 = touch->getDelta();
        if (!_isTouchScaleButton) {
            auto stickerPosition = _sticker->getPosition() + offsetVec2;
            _sticker->setPosition(stickerPosition);
            this->drawStickerRect();
        } else {
            
        }
    }

    return true;
}

bool StickerEditViewController::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event) {
    
    if (touch->getStartLocation() == touch->getLocation()) {
        if (_isTouchCloseButton) {
            auto scale0Action = ScaleTo::create(0.1f, 0.01f);
            auto removeAction = RemoveSelf::create();
            auto seqAction = Sequence::create(scale0Action, removeAction, NULL);
            _sticker->runAction(seqAction);
            this->clearEditView();
        } else if (_sticker) {
            log(">>>> %d", _sticker->getLocalZOrder());
            auto scaleInAction = ScaleTo::create(0.075f, 0.8f);
            auto scaleOutAction = ScaleTo::create(0.075f, 1.0f);
            auto seqAction = Sequence::create(scaleInAction, scaleOutAction, NULL);
            _sticker->runAction(seqAction);
        }

    }
//        _sticker = nullptr;
    _isTouchScaleButton = false;
    _isTouchCloseButton = false;
    return true;
}


void StickerEditViewController::drawStickerRect() {
    _drawNode->clear();
    
    auto stickerPosition = _sticker->getPosition();
    auto contentSize = _sticker->getContentSize();
    auto anchorPoint = _sticker->getAnchorPoint();
    auto halfSize = Size(contentSize.width * anchorPoint.x, contentSize.height * anchorPoint.y);
    auto topleft = Vec2(stickerPosition.x - halfSize.width, stickerPosition.y + contentSize.height - halfSize.height) + Vec2(-5, 5);
    auto bottomright = Vec2(stickerPosition.x + contentSize.width - halfSize.width, stickerPosition.y - halfSize.height) + Vec2(5, -5);
    _drawNode->drawRect(topleft, bottomright, Color4F(1.0f, 1.0f ,1.0f , 0.5f));
    
    _editStickerCloseButton->setPosition(topleft);
    _scaleStickerButton->setPosition(bottomright);
    _editStickerCloseButton->setVisible(true);
    _scaleStickerButton->setVisible(true);
}

void StickerEditViewController::clearEditView() {
    _sticker = nullptr;
    _drawNode->clear();
    _editStickerCloseButton->setVisible(false);
    _scaleStickerButton->setVisible(false);
}
