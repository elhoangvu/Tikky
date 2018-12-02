//
//  StickerEditViewController.hpp
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#ifndef StickerEditViewController_h
#define StickerEditViewController_h

#include "cocos2d.h"
#include "StickerType.h"

class StickerEditViewController : public cocos2d::Node {
protected:
    cocos2d::Node* _stickersParent;
    cocos2d::Node* _sticker;
    bool _isEnable;
    
    int _frontZOrder;
    int _isTouchCloseButton;
    int _isTouchScaleButton;
    cocos2d::DrawNode* _drawNode;
    cocos2d::Sprite* _editStickerCloseButton;
    cocos2d::Sprite* _scaleStickerButton;
    
    void drawStickerRect();
    void clearEditView();
    
    enum StickerEditType {
        CLOSE_EDIT_BUTTON = 200,
        SCALE_STICKER_BUTTON
    };
    
private:
    StickerEditViewController() {};
    
    bool onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event);
    bool onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event);
    bool onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event);
public:
    static StickerEditViewController* create(cocos2d::Node* stickersParent, cocos2d::Node* sticker = nullptr);
    
    cocos2d::Node* getSticker();
    void setSticker(cocos2d::Node* sticker);
    
    void setEnable(bool enable);
    bool isEnable();
    
    int getFrontZOrder();

    bool init(cocos2d::Node* stickersParent, cocos2d::Node* sticker);
};

#endif /* StickerEditViewController_hpp */
