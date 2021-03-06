#import "VENTouchLockPasscodeView.h"
#import "VENTouchLockPasscodeCharacterView.h"
@import AudioToolbox;

@interface VENTouchLockPasscodeView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *firstCharacter;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *secondCharacter;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *thirdCharacter;
@property (weak, nonatomic) IBOutlet VENTouchLockPasscodeCharacterView *fourthCharacter;

@end

@implementation VENTouchLockPasscodeView

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                      owner:self options:nil];
    self = [nibArray firstObject];
    if (self) {
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        _title = title;
        _titleLabel.text = title;
        _characters = @[_firstCharacter, _secondCharacter, _thirdCharacter, _fourthCharacter];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitle:@"" frame:frame];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)shakeAndVibrateCompletion:(void (^)())completionBlock
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completionBlock) {
            completionBlock();
        }
    }];
    NSString *keyPath = @"position";
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:keyPath];
    [animation setDuration:0.04];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    CGFloat delta = 10.0;
    CGPoint center = self.center;
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(center.x - delta, center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(center.x + delta, center.y)]];
    [[self layer] addAnimation:animation forKey:keyPath];
    [CATransaction commit];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

@end