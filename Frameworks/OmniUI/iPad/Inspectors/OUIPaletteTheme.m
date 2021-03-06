// Copyright 2010 The Omni Group.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import <OmniUI/OUIPaletteTheme.h>

#import <OmniQuartz/OQColor.h>

RCS_ID("$Id$");

@implementation OUIPaletteTheme

+ (NSArray *)defaultThemes;
{
    NSString *path = [OMNI_BUNDLE pathForResource:@"OUIDefaultPaletteThemes" ofType:@"plist"];
    if (!path) {
        OBASSERT_NOT_REACHED("No themes");
        return nil;
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (!data) {
        NSLog(@"Unable to load theme file %@: %@", path, [error toPropertyList]);
        return nil;
    }
    
    NSString *errorDescription = nil;
    NSArray *dictionaries = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&errorDescription];
    if (!dictionaries) {
        NSLog(@"Unable to parse theme file %@: %@", path, errorDescription);
        [errorDescription release]; // API says we own this.
        return nil;
    }
    
    NSMutableArray *themes = [NSMutableArray array];
    for (NSDictionary *dict in dictionaries) {
        OUIPaletteTheme *theme = [[OUIPaletteTheme alloc] initWithDictionary:dict stringTable:@"OUIDefaultPaletteThemes" bundle:OMNI_BUNDLE];
        if (!theme) {
            NSLog(@"cannot create theme from dict %@", dict);
            continue;
        }
        [themes addObject:theme];
        [theme release];
    }
    
    return themes;
}

- initWithDictionary:(NSDictionary *)dict stringTable:(NSString *)stringTable bundle:(NSBundle *)bundle;
{
    if (!(self = [super init]))
        return nil;
    
    _identifier = [[dict objectForKey:@"identifier"] copy];
    if (!_identifier) {
        [self release];
        return nil;
    }
    
    _displayName = [[bundle localizedStringForKey:_identifier value:_identifier table:stringTable] copy];
    OBASSERT(OFNOTEQUAL(_displayName, _identifier)); // No string table or no entry for this identifier?
    
    NSMutableArray *colors = [NSMutableArray array];
    NSArray *colorPlists = [dict objectForKey:@"colors"];
    for (id colorPlist in colorPlists) {
        OQColor *color = nil;
        if ([colorPlist isKindOfClass:[NSString class]]) {
            color = [OQColor colorFromRGBAString:colorPlist];
        } else {
            OBASSERT_NOT_REACHED("Don't understand this kind of plist for colors");
        }
        
        if (color)
            [colors addObject:color];
    }
    
    if ([colors count] == 0) {
        OBASSERT_NOT_REACHED("No colors read");
        [self release];
        return nil;
    }
    
    _colors = [colors copy];
    
    return self;
}

- (void)dealloc;
{
    [_identifier release];
    [_displayName release];
    [_colors release];
    [super dealloc];
}

@synthesize identifier = _identifier;
@synthesize displayName = _displayName;
@synthesize colors = _colors;

@end
