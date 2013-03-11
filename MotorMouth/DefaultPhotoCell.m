//
//  DefaultPhotoCell.m
//  Puzzle
//
//  Created by John Tubert on 12/21/09.
//  Copyright 2009 jtubert.com. All rights reserved.
//

#import "DefaultPhotoCell.h"
#import "mmObject.h"


@implementation DefaultPhotoCell

@synthesize image1, image2, image3, dataObject1, dataObject2, dataObject3;


// the reason I don't synthesize setters for 'orderText' and 'scoreText' is because I need to 
// call -setNeedsDisplay when they change

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //do things
    }
    return self;
}

- (void)setImage1:(UIImage *)i
{
	image1 = i;
	[self setNeedsDisplay]; 
}

- (void)setImage2:(UIImage *)i
{
	image2 = i;
	[self setNeedsDisplay]; 
}

- (void)setImage3:(UIImage *)i
{
	image3 = i;
	[self setNeedsDisplay]; 
}

- (void) imageClick1{
	//This is notification is handle in PickPhotoSource.m
	[[NSNotificationCenter defaultCenter] postNotificationName:@"defaultPhotoPressed" object:dataObject1];
	NSLog(@"imageClick1 %@",dataObject1);
}

- (void) imageClick2{
	//This is notification is handle in PickPhotoSource.m
	[[NSNotificationCenter defaultCenter] postNotificationName:@"defaultPhotoPressed" object:dataObject2];
	NSLog(@"imageClick2 %@",dataObject2);
}

- (void) imageClick3{
	//This is notification is handle in PickPhotoSource.m
	[[NSNotificationCenter defaultCenter] postNotificationName:@"defaultPhotoPressed" object:dataObject3];
	NSLog(@"imageClick3 %@",dataObject3);
}

- (void)drawContentView:(CGRect)r
{
	//NSLog(@"drawContentView");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *backgroundColor = [UIColor clearColor];
	
	
	if(self.selected)
	{
		backgroundColor = [UIColor clearColor];
		
	}
	
	[backgroundColor set];
	CGContextFillRect(context, r);
	
	CGPoint p;
	p.x = 13;
	p.y = 5;
	
	//[image1 drawAtPoint:CGPointMake(p.x,p.y)];
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(p.x, p.y, 84, 84)];
	UIImage *normalStateImage = image1;	
	[btn1 setBackgroundImage:normalStateImage forState:UIControlStateNormal];
	[btn1 addTarget:self action:@selector(imageClick1) forControlEvents:UIControlEventTouchUpInside];
	btn1.backgroundColor = [UIColor clearColor];
	[self addSubview:btn1];	
	
	p.x+=(84+16);
	//[image2 drawAtPoint:CGPointMake(p.x,p.y)];
	UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(p.x, p.y, 84, 84)];
	UIImage *normalStateImage2 = image2;	
	[btn2 setBackgroundImage:normalStateImage2 forState:UIControlStateNormal];
	[btn2 addTarget:self action:@selector(imageClick2) forControlEvents:UIControlEventTouchUpInside];
	btn2.backgroundColor = [UIColor clearColor];
	[self addSubview:btn2];	
	
	p.x+=(84+16);
	//[image3 drawAtPoint:CGPointMake(p.x,p.y)];
	UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(p.x, p.y, 84, 84)];
	UIImage *normalStateImage3 = image3;	
	[btn3 setBackgroundImage:normalStateImage3 forState:UIControlStateNormal];
	[btn3 addTarget:self action:@selector(imageClick3) forControlEvents:UIControlEventTouchUpInside];
	btn3.backgroundColor = [UIColor clearColor];
	[self addSubview:btn3];	
}

@end
