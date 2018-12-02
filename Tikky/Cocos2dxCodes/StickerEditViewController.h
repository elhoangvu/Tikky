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
#include "PinchGestureRecognizer.h"
#include "PanGestureRecognizer.h"

class StickerEditViewController : public cocos2d::Node {
protected:
    cocos2d::Sprite* _recyclingBin;
    cocos2d::Node* _sticker;
    bool _isEnable;
    bool _isPinching;
    int _frontZOrder;

private:
    StickerEditViewController() {};
    void tapStickerAnimation();
    
    bool onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event);
    bool onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event);
    bool onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event);
    
    void onPinch(cocos2d::PinchGestureRecognizer* recognizer);
    void onPan(cocos2d::PanGestureRecognizer* recognizer);
public:
    static StickerEditViewController* create();
    
    cocos2d::Node* getSticker();
    void setSticker(cocos2d::Node* sticker);
    
    void setEnable(bool enable);
    bool isEnable();
    
    int getFrontZOrder();
    
    void addSticker(cocos2d::Sprite* sticker);
    void removeAllSticker();

    bool init();
};

#endif /* StickerEditViewController_hpp */
