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

#include "StickerScene.h"
#include "SimpleAudioEngine.h"
#include "scripting/lua-bindings/manual/CCComponentLua.h"
//#include "editor-support/spine/SkeletonAnimation.h"

#define FRAME_STICKER_Z_POSITION 100000

USING_NS_CC;

Scene* StickerScene::createScene()
{
    return StickerScene::create();
}

// Print useful error message instead of segfaulting when files are not there.
static void problemLoading(const char* filename)
{
    printf("Error while loading: %s\n", filename);
    printf("Depending on how you compiled you might have to add 'Resources/' in front of filenames in HelloWorldScene.cpp\n");
}

// on "init" you need to initialize your instance
bool StickerScene::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Scene::init() )
    {
        return false;
    }

//    _isAvailableFrameSticker = false;
    _stickerEditVC = StickerEditController::create();
    _enableFacialSticker = false;
    this->setMaxFaceNum(1);
    
    this->addChild(_stickerEditVC);
    onEditStickerBegan = nullptr;
    onEditStickerEnded = nullptr;
    
    // Set up callback functions for _stickerEditVC (StickerEditController)
    _stickerEditVC->onEditStickerBegan = [this]() {
        if (this->onEditStickerBegan) {
            this->onEditStickerBegan();
        }
    };
    
    _stickerEditVC->onEditStickerEnded = [this]() {
        if (this->onEditStickerEnded) {
            this->onEditStickerEnded();
        }
    };
    
    _stickerEditVC->onTouchStickerBegan = [this]() {
        if (this->onTouchStickerBegan) {
            this->onTouchStickerBegan();
        }
    };

    return true;
}

bool StickerScene::enableFacialSticker() {
    return _enableFacialSticker;
}

std::vector<TKCCTexture>* StickerScene::getTexturesInScene()
{
    std::vector<TKCCTexture>* texturesInRunningScene = Director::getInstance()->getTKTexturesInRunningScene();
    log("%lu", texturesInRunningScene->size());
    return texturesInRunningScene;
}

void StickerScene::newStaticStickerWithPath(std::string path) {
    TKSticker sticker;
    sticker.path = path;
    sticker.allowChanges = true;

    this->newStickerWithSticker(sticker);
}

void StickerScene::newStaticStickerWithSticker(TKSticker sticker) {
    this->newStickerWithSticker(sticker);
}

void StickerScene::newFrameStickerWithSticker(TKSticker sticker) {
    Node* sticker_ = this->newStickerWithSticker(sticker, true);
    
    if (sticker_) {
        if (!sticker_->getComponent("TKComponent")) {
            auto visibleSize = Director::getInstance()->getVisibleSize();
            Vec2 origin = Director::getInstance()->getVisibleOrigin();
            sticker_->setPosition(Vec2(visibleSize.width*0.5f + origin.x, visibleSize.height*0.5f + origin.y));
            Size size = sticker_->getContentSize();
            sticker_->setScaleX(visibleSize.width/size.width);
            sticker_->setScaleY(visibleSize.height/size.height);
        }
        _frameStickers.push_back(sticker_);
    }
}

void StickerScene::newFrameStickerWithStickers(std::vector<TKSticker>& stickers) {
    for (TKSticker& sticker : stickers) {
        this->newFrameStickerWithSticker(sticker);
    }
}

Node* StickerScene::newStickerWithSticker(TKSticker sticker, bool isFrameSticker) {
    auto sticker_ = Sprite::create(sticker.path);
    if (!sticker_) {
        log(">>>> TIKKY: Can not create new sticker with path %s", sticker.path.c_str());
        return nullptr;
    }

    // Set Lua component for sticker Node
    bool isHaveComponentLua = false;
    if (sticker.luaComponentPath != "") {
        ComponentLua* componentLua = ComponentLua::create(sticker.luaComponentPath);
        componentLua->setName("TKComponent");
        if (componentLua) {
            sticker_->addComponent(componentLua);
            isHaveComponentLua = true;
        }
    }
    
    // If the node have not lua component, the node will be set by default properties: size, position.
    if (!isHaveComponentLua) {
        auto visibleSize = Director::getInstance()->getVisibleSize();
        Vec2 origin = Director::getInstance()->getVisibleOrigin();
        sticker_->setPosition(Vec2(visibleSize.width*0.5f + origin.x, visibleSize.height*0.5f + origin.y));
    }

    if (sticker.allowChanges) {
        int tag = StickerType::STATIC_STICKER;
        if (isFrameSticker) {
            tag |= StickerType::FRAME_STICKER;
        }
        sticker_->setTag(tag);
        _stickerEditVC->addSticker(sticker_, true);
    } else {
        sticker_->setTag(StickerType::FRAME_STICKER);
        this->addChild(sticker_, FRAME_STICKER_Z_POSITION);
    }
    
    return sticker_;
}

void StickerScene::newFacialStickerWithStickers(std::vector<TKSticker>& stickers) {
    if (stickers.size() == 0) {
        return;
    }

    this->removeAllFacialSticker();
    _enableFacialSticker = true;
    
    for (int i = 0; i < _maxFaceNum; i++) {
        for (auto& sticker : stickers) {
            Node* sticker_ = this->newStickerWithSticker(sticker);
            if (sticker_) {
                _facialStickers[i].push_back(sticker_);
                if (sticker.neededLandmarks.size() > 0) {
                    sticker_->setUserData(new std::vector<int>(sticker.neededLandmarks));
                }
            }
        }
    }
}

void StickerScene::updateFacialLandmarks(float** landmarks, int numLandmarks, int numFaces) {
    if (!landmarks || numLandmarks <= 0) {
        return;
    }
    _facialStickerMutex.lock();
    int i;
    for (i = 0; i < numFaces; i++) {
        std::vector<Node *> visibleStickers = _facialStickers.at(i);
        for (auto sticker : visibleStickers) {
            ComponentLua* compLua = dynamic_cast<ComponentLua *>(sticker->getComponent("TKComponent"));
            if (sticker && compLua) {
                std::vector<int>* neededLmks = (std::vector<int> *)sticker->getUserData();
                if (neededLmks) {
                    int numLmks = (int)neededLmks->size();
                    float* lmks = new float[numLmks*2];
                    for (int j = 0; j < numLmks; j++) {
                        lmks[j] = landmarks[i][neededLmks->at(j)];
                        lmks[j + numLmks] = landmarks[i][neededLmks->at(j) + numLandmarks];
                    }
                    compLua->executeFunctionWithFloatArgs("updateLandmarks", lmks, numLmks*2);
                    if (lmks)
                        delete[] lmks;
                }
            }
        }
    }
    for (; i < _maxFaceNum; i++) {
        std::vector<Node *> visibleStickers = _facialStickers.at(i);
        for (auto sticker : visibleStickers) {
            ComponentLua* compLua = dynamic_cast<ComponentLua *>(sticker->getComponent("TKComponent"));
            if (sticker && compLua) {
                compLua->executeFunctionWithFloatArgs("notifyNoFaceDetected", nullptr, 0);
            }
        }
    }
    _facialStickerMutex.unlock();
}

void StickerScene::notifyNoFaceDetected() {
    for (auto& stickerPacket : _facialStickers) {
        for (auto sticker : stickerPacket) {
            ComponentLua* compLua = dynamic_cast<ComponentLua *>(sticker->getComponent("TKComponent"));
            if (sticker && compLua) {
                compLua->executeFunctionWithFloatArgs("notifyNoFaceDetected", nullptr, 0);
            }
        }
    }
}

void StickerScene::removeAllStaticSticker() {
    _enableFacialSticker = false;
    _stickerEditVC->removeAllSticker();
}

void StickerScene::removeAllFrameSticker() {
    for (Node* sticker : _frameStickers) {
        if (sticker->getTag() == StickerType::FRAME_STICKER) {
            sticker->removeFromParentAndCleanup(true);
        } else {
            _stickerEditVC->removeSticker(sticker, true);
        }
    }
    _frameStickers.clear();
}

void StickerScene::removeAllFacialSticker() {
    _facialStickerMutex.lock();
    for (auto& stickerPacket : _facialStickers) {
        for (Node* sticker : stickerPacket) {
            std::vector<int>* neededLmks = (std::vector<int> *)sticker->getUserData();
            if (neededLmks)
                delete neededLmks;
            if (sticker->getTag() == StickerType::FRAME_STICKER) {
                sticker->removeFromParentAndCleanup(true);
            } else {
                _stickerEditVC->removeSticker(sticker, true);
            }
        }
        stickerPacket.resize(0);
    }
    _facialStickerMutex.unlock();
}

bool StickerScene::onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event) {

    return false;
}

bool StickerScene::onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event) {

    return true;
}

bool StickerScene::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event) {

    return true;
}

void StickerScene::setMaxFaceNum(int maxFaceNum) {
    _maxFaceNum = maxFaceNum;
    _facialStickers.resize(_maxFaceNum);
}
