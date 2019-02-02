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
    
//    log("%f, %f", Director::getInstance()->getVisibleSize().width, Director::getInstance()->getVisibleSize().height);
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
//    utils::captureScreen(CC_CALLBACK_2(HelloWorld::afterCaptured, this), "screenshot.png");
    
    
//    Size screenSize = Director::getInstance()->getWinSize();
//    RenderTexture * tex = RenderTexture::create(screenSize.width, screenSize.height);
//    tex->setPosition(Point(screenSize.width/2, screenSize.height/2));
//
//    tex->begin();
//    this->getParent()->visit();
//    tex->end();
//
//    tex->saveToFile("Image_Save.png", Image::Format::PNG);
    //callback function
}

void StickerScene::newStaticStickerWithPath(std::string path) {
    TKSticker sticker;
    sticker.path = path;
    sticker.allowChanges = true;

    this->newStickerWithSticker(sticker);
//    auto visibleSize = Director::getInstance()->getVisibleSize();
//    Vec2 origin = Director::getInstance()->getVisibleOrigin();
//
//    auto sticker = Sprite::create(path);
//    if (!sticker) {
//        log(">>>> TIKKY: Can not create new sticker with path %s", path.c_str());
//        return;
//    }
//    sticker->setTag(StickerType::STATIC_STICKER);
//    sticker->setPosition(Vec2(visibleSize.width*0.5f + origin.x, visibleSize.height*0.5f + origin.y));
////    ComponentLua* componentLua = ComponentLua::create("testLua.lua");
////    sticker->addComponent(componentLua);
//    _stickerEditVC->addSticker(sticker, true);
}

void StickerScene::newStaticStickerWithSticker(TKSticker sticker) {
    this->newStickerWithSticker(sticker);
}
//#include <chrono>
void StickerScene::newFrameStickerWithSticker(TKSticker sticker) {
    Node* sticker_ = this->newStickerWithSticker(sticker);
//    auto component = (ComponentLua *)sticker_->getComponent("TKComponent");
//    float f[68];
//    for (int i=0;i<68;i++) {
//        f[i] = i*100;
//    }
//    auto t_start = std::chrono::high_resolution_clock::now();
//    component->executeFunctionWithFloatArgs("onCall", f, 68);
//    component->executeFunctionWithFloatArgs("onCall2", f, 68);
//    component->executeFunctionWithFloatArgs("onCall3", f, 68);
//    component->executeFunctionWithFloatArgs("onCall4", f, 68);
//    auto t_end = std::chrono::high_resolution_clock::now();
//
//    double elaspedTimeMs = std::chrono::duration<double, std::milli>(t_end-t_start).count();
//    printf("Time: %f", elaspedTimeMs);
    
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
        this->addChild(sticker_);
    }
    
    return sticker_;
}

void StickerScene::newFacialStickerWithStickers(std::vector<TKSticker>& stickers) {
    if (stickers.size() == 0) {
        return;
    }
    this->removeAllFacialSticker();
    _enableFacialSticker = true;
    for (auto sticker : stickers) {
        Node* sticker_ = this->newStickerWithSticker(sticker);
        if (sticker_) {
            sticker_->setVisible(false);
            _facialStickers.push_back(sticker_);
            if (sticker.neededLandmarks.size() > 0) {
                sticker_->setUserData(new std::vector<int>(sticker.neededLandmarks));
            }
        }
    }
    
}

void StickerScene::updateFacialLandmarks(const float* landmarks, int numLandmarks) {
    for (auto sticker : _facialStickers) {
        ComponentLua* compLua = dynamic_cast<ComponentLua *>(sticker->getComponent("TKComponent"));
        if (sticker && compLua) {
            sticker->setVisible(true);
            std::vector<int>* neededLmks = (std::vector<int> *)sticker->getUserData();
            if (neededLmks) {
                int numLmks = (int)neededLmks->size();
                float* lmks = new float[numLmks*2];
                for (int i = 0; i < numLmks; i++) {
                    lmks[i] = landmarks[neededLmks->at(i)];
                    lmks[i + numLmks] = landmarks[neededLmks->at(i) + numLandmarks];
                }
                compLua->executeFunctionWithFloatArgs("updateLandmarks", lmks, numLmks*2);
                if (lmks)
                    delete[] lmks;
            }
        }
    }
}

void StickerScene::notifyDetectNoFaces() {
    for (auto sticker : _facialStickers) {
        sticker->setVisible(false);
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
    for (Node* sticker : _facialStickers) {
        if (sticker->getTag() == StickerType::FRAME_STICKER) {
            sticker->removeFromParentAndCleanup(true);
        } else {
            _stickerEditVC->removeSticker(sticker, true);
        }
        std::vector<int>* neededLmks = (std::vector<int> *)sticker->getUserData();
        if (neededLmks)
            delete neededLmks;
    }
    _facialStickers.clear();
}
//
//void StickerScene::newFrameStickerWithPath(std::string path) {
//
//    auto visibleSize = Director::getInstance()->getVisibleSize();
//    Vec2 origin = Director::getInstance()->getVisibleOrigin();
//
//    auto frameSticker = Sprite::create(path);
//    if (!_frameSticker) {
//        log(">>>> TIKKY: Can not create new sticker with path %s", path.c_str());
//        return;
//    }
//    if (_isAvailableFrameSticker) {
//        this->removeFrameSticker();
//        _frameSticker = frameSticker;
//    }
//
//    _isAvailableFrameSticker = true;
//    _frameSticker->setTag(StickerType::FRAME_STICKER);
//    _frameSticker->setPosition(Vec2(visibleSize.width*0.5f + origin.x, visibleSize.height*0.5f + origin.y));
//    float xscale = _frameSticker->getContentSize().width / visibleSize.width;
//    float yscale = _frameSticker->getContentSize().height / visibleSize.height;
//    _frameSticker->setScale(MIN(xscale, yscale));
//
//    this->addChild(_frameSticker, 100000);
//}
//
//void StickerScene::newFrameStickerWith2PartTopBot(std::string topFramePath, std::string bottomFramePath) {
//    auto visibleSize = Director::getInstance()->getVisibleSize();
//    Vec2 origin = Director::getInstance()->getVisibleOrigin();
//
//    auto topSticker = Sprite::create(topFramePath);
//    auto botSticker = Sprite::create(bottomFramePath);
//    if (!topSticker || !botSticker) {
//        log(">>>> TIKKY: Can not create new sticker with path %s or %s", topFramePath.c_str(), bottomFramePath.c_str());
//        return;
//    }
//    if (_isAvailableFrameSticker) {
//        this->removeFrameSticker();
//        _twoPartFrameSticker[0] = topSticker;
//        _twoPartFrameSticker[1] = botSticker;
//    }
//
//    _isAvailableFrameSticker = true;
//    topSticker->setTag(StickerType::FRAME_STICKER);
//    topSticker->setAnchorPoint(Vec2(0.0f, 1.0f));
//    topSticker->setPosition(Vec2(origin.x, visibleSize.height + origin.y));
//    topSticker->setScale(visibleSize.width / topSticker->getContentSize().width);
//    this->addChild(topSticker, 100000);
//
//    botSticker->setTag(StickerType::FRAME_STICKER);
//    botSticker->setAnchorPoint(Vec2::ZERO);
//    botSticker->setPosition(Vec2(origin.x, origin.y));
//    botSticker->setScale(visibleSize.width / botSticker->getContentSize().width);
//    this->addChild(botSticker, 100000);
//}
//
//void StickerScene::newFrameStickerWith2PartLeftRight(std::string leftFramePath, std::string rightFramePath) {
//    auto visibleSize = Director::getInstance()->getVisibleSize();
//    Vec2 origin = Director::getInstance()->getVisibleOrigin();
//
//    auto leftSticker = Sprite::create(leftFramePath);
//    auto rightSticker = Sprite::create(rightFramePath);
//    if (!leftSticker || !rightSticker) {
//        log(">>>> TIKKY: Can not create new sticker with path %s or %s", leftFramePath.c_str(), rightFramePath.c_str());
//        return;
//    }
//    if (_isAvailableFrameSticker) {
//        this->removeFrameSticker();
//        _twoPartFrameSticker[0] = leftSticker;
//        _twoPartFrameSticker[1] = rightSticker;
//    }
//
//    _isAvailableFrameSticker = true;
//    leftSticker->setTag(StickerType::FRAME_STICKER);
//    leftSticker->setAnchorPoint(Vec2::ZERO);
//    leftSticker->setPosition(Vec2(origin.x, origin.y));
//    leftSticker->setScale(visibleSize.height / leftSticker->getContentSize().height);
//    this->addChild(leftSticker, 100000);
//
//    rightSticker->setTag(StickerType::FRAME_STICKER);
//    rightSticker->setAnchorPoint(Vec2(1.0f, 0.0f));
//    rightSticker->setPosition(Vec2(visibleSize.width + origin.x, origin.y));
//    rightSticker->setScale(visibleSize.height / rightSticker->getContentSize().height);
//    this->addChild(rightSticker, 100000);
//}

//void StickerScene::removeFrameSticker() {
//    _isAvailableFrameSticker = false;
//    if (_frameSticker) {
//        _frameSticker->removeFromParentAndCleanup(true);
//    } else {
//        if (_twoPartFrameSticker[0]) {
//            _twoPartFrameSticker[0]->removeFromParentAndCleanup(true);
//        }
//        if (_twoPartFrameSticker[1]) {
//            _twoPartFrameSticker[1]->removeFromParentAndCleanup(true);
//        }
//    }
//}

bool StickerScene::onTouchBegan(cocos2d::Touch *touch, cocos2d::Event *event) {

    return false;
}

bool StickerScene::onTouchMoved(cocos2d::Touch *touch, cocos2d::Event * event) {

    return true;
}

bool StickerScene::onTouchEnded(cocos2d::Touch *touch, cocos2d::Event *event) {

    return true;
}