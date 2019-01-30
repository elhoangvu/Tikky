//
//  StickerEditController.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#ifndef StickerEditController_h
#define StickerEditController_h

#include "cocos2d.h"
#include "StickerType.h"
#include "PinchGestureRecognizer.h"
#include "PanGestureRecognizer.h"

class StickerEditController : public cocos2d::Node {
protected:
    // A area to remove sticker by move touch
    cocos2d::Node* _recyclingArea;
    
    // A sprite is recycling bin
    cocos2d::Sprite* _recyclingBin;
    
    // Current sticker is interacted
    cocos2d::Node* _sticker;
    
    bool _isEnable;
    bool _isPinching;
    
    // A front Z coordination: Z coord of sticker in front of scene.
    int _frontZOrder;
    
    // Count a number of touch on sticker
    int _touchStickerCount;

private:
    StickerEditController() {};
    
    // Run amination when tap sticker
    void tapStickerAnimation();
    
    // Interactions
    bool onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event);
    bool onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event);
    bool onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event);
    void onPinch(cocos2d::PinchGestureRecognizer* recognizer);
    void onPan(cocos2d::PanGestureRecognizer* recognizer);
public:
    // Callback funtions
    std::function<void()> onTouchStickerBegan;
    std::function<void()> onEditStickerBegan;
    std::function<void()> onEditStickerEnded;
    
    // A static creater
    static StickerEditController* create();
    
    // Get current sticker being interacted
    cocos2d::Node* getSticker();
    
    // Set new sticker - change sticker
    void setSticker(cocos2d::Node* sticker);
    
    void setEnable(bool enable);
    bool isEnable();
    
    int getFrontZOrder();
    
    /**
     Add new sticker to the scene

     @param sticker New sticker will be added
     @param isAnimation An animation for sticker addition
     */
    void addSticker(cocos2d::Sprite* sticker, bool isAnimation = false);
    
    void removeAllSticker();
    void removeSticker(cocos2d::Node* sticker, bool isCleanup);
    bool init();
};

#endif /* StickerEditController_h */
