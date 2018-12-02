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
//#include "scripting/lua-bindings/manual/CCComponentLua.h"
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

    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
//    auto closeItem = MenuItemImage::create(
//                                           "HelloWorld.png",
//                                           "HelloWorld.png",
//                                           CC_CALLBACK_1(StickerScene::getTexturesInScene, this));
//
//    if (closeItem == nullptr ||
//        closeItem->getContentSize().width <= 0 ||
//        closeItem->getContentSize().height <= 0)
//    {
//        problemLoading("'CloseNormal.png' and 'CloseSelected.png'");
//    }
//    else
//    {
////        float x = origin.x + visibleSize.width - closeItem->getContentSize().width/2;
////        float y = origin.y + closeItem->getContentSize().height/2;
////        closeItem->setPosition(Vec2(x,y));
//        closeItem->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));
//    }
////
////    // create menu, it's an autorelease object
//    auto menu = Menu::create(closeItem, NULL);
//    menu->setPosition(Vec2::ZERO);
//    this->addChild(menu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label

//    auto label = Label::createWithTTF("Hello World", "fonts/Marker Felt.ttf", 24);
//    if (label == nullptr)
//    {
//        problemLoading("'fonts/Marker Felt.ttf'");
//    }
//    else
//    {
//        // position the label on the center of the screen
//        label->setPosition(Vec2(origin.x + visibleSize.width/2,
//                                origin.y + visibleSize.height - label->getContentSize().height));
//
//        // add the label as a child to this layer
//        this->addChild(label, 1);
//    }
//
    // add "HelloWorld" splash screen"
    auto sprite = Sprite::create("HelloWorld.png");
    sprite->setPosition(Vec2(visibleSize.width/2.2 + origin.x, visibleSize.height/2.2 + origin.y));
    sprite->setTag(StickerType::STATIC_STICKER);
    this->addChild(sprite, 0);
    
    auto sprite2 = Sprite::create("HelloWorld2.png");
    sprite2->setPosition(Vec2(visibleSize.width/2 + origin.x, visibleSize.height/2 + origin.y));
    sprite2->setTag(StickerType::STATIC_STICKER);
    this->addChild(sprite2, 1);
        
    _nextStickerZOrder = 2;
    _stickerEditVC = StickerEditViewController::create(this);
    this->addChild(_stickerEditVC, 100000);
//    ComponentLua* componentLua = ComponentLua::create("player.lua");
//    sprite->addComponent(componentLua);

//    auto skeleton = spine::SkeletonAnimation::createWithJsonFile("alien-pro.json", "alien.atlas");
//    skeleton->setPosition(visibleSize/2.0);
//    skeleton->setScale(0.2f);
//    skeleton->setAnimation(0, "run", true);
//    this->addChild(skeleton);

    return true;
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

void StickerScene::newStickerWithPath(std::string path) {
    
    auto visibleSize = Director::getInstance()->getVisibleSize();
    Vec2 origin = Director::getInstance()->getVisibleOrigin();

    auto sticker = Sprite::create(path);
    sticker->setTag(StickerType::STATIC_STICKER);
    sticker->setPosition(Vec2(visibleSize.width/2.5 + origin.x, visibleSize.height/2.5 + origin.y));
    log(">>>> %f %f", sticker->getPosition().x, sticker->getPosition().y);
    int zOrder = _stickerEditVC->getFrontZOrder() + 1;
    if (_nextStickerZOrder < zOrder) {
        _nextStickerZOrder = zOrder;
    }
    this->addChild(sticker, _nextStickerZOrder++);
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
