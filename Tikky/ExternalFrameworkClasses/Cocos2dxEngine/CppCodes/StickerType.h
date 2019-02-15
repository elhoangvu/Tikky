//
//  StickerType.h
//  Tikky
//
//  Created by Le Hoang Vu on 12/2/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#ifndef StickerType_h
#define StickerType_h

enum StickerType {
    STATIC_STICKER      = 1,
    FRAME_STICKER       = 1 << 1,
    ANIMATION_STICKER   = 1 << 2,
    FACIAL_STICKER       = 1 << 1,
};

#endif /* StickerTypes_h */
