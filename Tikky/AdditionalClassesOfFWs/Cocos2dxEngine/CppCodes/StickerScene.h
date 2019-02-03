/****************************************************************************
 Copyright (c) 2017-2018 Xiamen Yaji Software Co., Ltd.
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#ifndef __STICKER_SCENE_H__
#define __STICKER_SCENE_H__

#include "StickerEditController.h"

#include <mutex>

typedef struct {
    std::string path;
    std::string luaComponentPath;
    std::vector<int> neededLandmarks;
    bool allowChanges;
} TKSticker;

class StickerScene : public cocos2d::Scene
{
private:
    
    // A controller to handle and process events for the StickerScene
    StickerEditController* _stickerEditVC;

    // A array of frame sticker's stickers
    std::vector<cocos2d::Node *> _frameStickers;
    
    std::vector<cocos2d::Node *> _facialStickers;
    
    std::mutex _facialStickerMutex;
    
    bool _enableFacialSticker;
    
private:
    /**
     Create news sticker node frome TKSticker

     @param sticker A TKSticker to descript a sticker node creation. See TKSticker struct
     @param isFrameSticker If true, Scene will disable interactions for the sticker.
     @return A cocos2d node sticker likes description
     */
    cocos2d::Node* newStickerWithSticker(TKSticker sticker, bool isFrameSticker = false);
    
    bool onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event);
    bool onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event);
    bool onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event);
public:
    // Callback function for C++11
    std::function<void()> onTouchStickerBegan;
    std::function<void()> onEditStickerBegan;
    std::function<void()> onEditStickerEnded;
    
    // A static creater
    static cocos2d::Scene* createScene();

    virtual bool init();
    
    bool enableFacialSticker();

    /**
     Get all stickers (textures) in the scene, wraping textures by TKCCTexture array

     @return A array of TKCCTexture, see TKCCTexture struct.
     */
    std::vector<TKCCTexture>* getTexturesInScene();
    
    unsigned int getStickerCount();
    
    // Add new sticker with optional args
    void newStaticStickerWithPath(std::string path);
    void newStaticStickerWithSticker(TKSticker sticker);
    void newFrameStickerWithSticker(TKSticker sticker);
    void newFrameStickerWithStickers(std::vector<TKSticker>& stickers);
    void newFacialStickerWithStickers(std::vector<TKSticker>& stickers);
    
    void updateFacialLandmarks(const float* landmarks, int numLandmarks);
    void notifyDetectNoFaces();

    // Remove stickers
    void removeAllFrameSticker();
    void removeAllStaticSticker();
    void removeAllFacialSticker();
    
    // implement the "static create()" method manually
    CREATE_FUNC(StickerScene);
};

#endif // __STICKER_SCENE_H__
