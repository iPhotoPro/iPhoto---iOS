//
//  IPImageAdjustment.swift
//  iPhoto
//
//  Created by ngodacdu on 5/9/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import GPUImage

enum AdjustmentType {
    case Brightness
    case Contrast
    case Temperature
    case Exposure
    case HighlightShadow
    case Saturation
    case RGB
    case Hue
    case Level
    case Sharpness
    case Vignette
    case Gamma
    case Lookup
    case MonoChrome
    case FalseColor
    case Haze
    case Opacity
    case SolidColor
    case ChromaKey
}

class IPImageAdjustment: NSObject {
    
    class var shareInstance: IPImageAdjustment {
        struct Instance {
            static let instance = IPImageAdjustment()
        }
        return Instance.instance
    }
    
    /* 
        - GPUImageBrightnessFilter: Adjusts the brightness of the image
        - brightness: The adjusted brightness (-1.0 - 1.0, with 0.0 as the default)
     */
    let kBrightnessMin: CGFloat = -1.0
    let kBrightnessDefault: CGFloat = 0.0
    let kBrightnessMax: CGFloat = 1.0
    
    func filterBrightness(originImage: UIImage, brightness: CGFloat) -> UIImage {
        if brightness < kBrightnessMin {
            return originImage
        }
        if brightness > kBrightnessMax {
            return originImage
        }
        if let filter = filterWithType(.Brightness) as? GPUImageBrightnessFilter {
            filter.brightness = brightness
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageContrastFilter: Adjusts the contrast of the image
        - contrast: The adjusted contrast (0.0 - 4.0, with 1.0 as the default)
     */
    let kContrastMin: CGFloat = 0.0
    let kContrastDefault: CGFloat = 1.0
    let kContrastMax: CGFloat = 4.0
    
    func filterContrast(originImage: UIImage, contrast: CGFloat) -> UIImage {
        if contrast < kContrastMin {
            return originImage
        }
        if contrast > kContrastMax {
            return originImage
        }
        if let filter = filterWithType(.Contrast) as? GPUImageContrastFilter {
            filter.contrast = contrast
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageWhiteBalanceFilter: Adjusts the white balance of an image.
        - temperature: The temperature to adjust the image by, in ºK. 
            A value of 4000 is very cool and 7000 very warm. The default value is 5000.
            Note that the scale between 4000 and 5000 is nearly as visually significant as that between 5000 and 7000
        - tint: The tint to adjust the image by. A value of -200 is very green and 200 is very pink. The default value is 0.
     */
    let kTemperatureMin: CGFloat = 4000
    let kTemperatureDefault: CGFloat = 5000
    let kTemperatureMax: CGFloat = 7000
    
    let kTintMin: CGFloat = -200
    let kTintDefault: CGFloat = 0
    let kTintMax: CGFloat = 200
    
    func filterTemperature(originImage: UIImage, temperature: CGFloat, tint: CGFloat) -> UIImage {
        if temperature < kTemperatureMin {
            return originImage
        }
        if temperature > kTemperatureMax {
            return originImage
        }
        if tint < kTintMin {
            return originImage
        }
        if tint > kTintMax {
            return originImage
        }
        if let filter = filterWithType(.Temperature) as? GPUImageWhiteBalanceFilter {
            filter.temperature = temperature
            filter.tint = tint
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageExposureFilter: Adjusts the exposure of the image
        - exposure: The adjusted exposure (-10.0 - 10.0, with 0.0 as the default)
     */
    let kExposureMin: CGFloat = -10.0
    let kExposureDefault: CGFloat = 0.0
    let kExposureMax: CGFloat = 10.0
    
    func filterExposure(originImage: UIImage, exposure: CGFloat) -> UIImage {
        if exposure < kExposureMin {
            return originImage
        }
        if exposure > kExposureMax {
            return originImage
        }
        if let filter = filterWithType(.Contrast) as? GPUImageExposureFilter {
            filter.exposure = exposure
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageHighlightShadowFilter: Adjusts the shadows and highlights of an image
        - shadows: Increase to lighten shadows, from 0.0 to 1.0, with 0.0 as the default.
        - highlights: Decrease to darken highlights, from 1.0 to 0.0, with 1.0 as the default.
     */
    let kHighlightMin: CGFloat = 0.0
    let kHighlightDefault: CGFloat = 1.0
    let kHighlightMax: CGFloat = 1.0
    
    let kShadowMin: CGFloat = 0.0
    let kShadowDefault: CGFloat = 1.0
    let kShadowMax: CGFloat = 1.0
    
    func filterHighlightShadow(originImage: UIImage, highlight: CGFloat, shadow: CGFloat) -> UIImage {
        if highlight < kHighlightMin {
            return originImage
        }
        if highlight > kHighlightMax {
            return originImage
        }
        if shadow < kShadowMin {
            return originImage
        }
        if shadow > kShadowMax {
            return originImage
        }
        if let filter = filterWithType(.HighlightShadow) as? GPUImageHighlightShadowFilter {
            filter.highlights = highlight
            filter.shadows = shadow
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageSaturationFilter: Adjusts the saturation of an image
        - saturation: The degree of saturation or desaturation to apply to the image (0.0 - 2.0, with 1.0 as the default)
     */
    let kSaturationMin: CGFloat = 0.0
    let kSaturationDefault: CGFloat = 1.0
    let kSaturationMax: CGFloat = 2.0
    
    func filterSaturation(originImage: UIImage, saturation: CGFloat) -> UIImage {
        if saturation < kExposureMin {
            return originImage
        }
        if saturation > kExposureMax {
            return originImage
        }
        if let filter = filterWithType(.Contrast) as? GPUImageSaturationFilter {
            filter.saturation = saturation
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageRGBFilter: Adjusts the individual RGB channels of an image
        - red: Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
        - green:
        - blue:
     */
    let kRedMin: CGFloat = 0.0
    let kRedDefault: CGFloat = 1.0
    let kRedMax: CGFloat = 1.0
    
    let kGreenMin: CGFloat = 0.0
    let kGreenDefault: CGFloat = 1.0
    let kGreenMax: CGFloat = 1.0
    
    let kBlueMin: CGFloat = 0.0
    let kBlueDefault: CGFloat = 1.0
    let kBlueMax: CGFloat = 1.0
    
    func filterRGB(originImage: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat) -> UIImage {
        if red < kRedMin {
            return originImage
        }
        if red > kRedMax {
            return originImage
        }
        if green < kGreenMin {
            return originImage
        }
        if green > kGreenMax {
            return originImage
        }
        if blue < kBlueMin {
            return originImage
        }
        if blue > kBlueMax {
            return originImage
        }
        if let filter = filterWithType(.RGB) as? GPUImageRGBFilter {
            filter.red = red
            filter.green = green
            filter.blue = blue
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageHueFilter: Adjusts the hue of an image
        - hue: The hue angle, in degrees. 90 degrees by default
     */
    let kHueMin: CGFloat = 0.0
    let kHueDefault: CGFloat = 90.0
    let kHueMax: CGFloat = 360.0
    
    func filterHue(originImage: UIImage, hue: CGFloat) -> UIImage {
        if hue < kHueMin {
            return originImage
        }
        if hue > kHueMax {
            return originImage
        }
        if let filter = filterWithType(.Hue) as? GPUImageHueFilter {
            filter.hue = hue
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageLevelsFilter: Photoshop-like levels adjustment. 
        The min, max, minOut and maxOut parameters are floats in the range [0, 1]. 
        If you have parameters from Photoshop in the range [0, 255] you must first convert them to be [0, 1].
        The gamma/mid parameter is a float >= 0. This matches the value from Photoshop. 
        If you want to apply levels to RGB as well as individual channels you need to use this filter twice - first for the individual channels and then for all channels.
     */
    let kLevelMin: CGFloat = 0.0
    let kLevelMax : CGFloat = 1.0
    
    func filterLevel(originImage: UIImage, red: CGFloat, green: CGFloat, blue: CGFloat) -> UIImage {
        if red < kLevelMin {
            return originImage
        }
        if red > kLevelMax {
            return originImage
        }
        if green < kLevelMin {
            return originImage
        }
        if green > kLevelMax {
            return originImage
        }
        if blue < kLevelMin {
            return originImage
        }
        if blue > kLevelMax {
            return originImage
        }
        if let filter = filterWithType(.Level) as? GPUImageLevelsFilter {
            filter.setRedMin(red, gamma: kLevelMax, max: kLevelMax, minOut: kLevelMin, maxOut: kLevelMax)
            filter.setGreenMin(green, gamma: kLevelMax, max: kLevelMax, minOut: kLevelMin, maxOut: kLevelMax)
            filter.setBlueMin(blue, gamma: kLevelMax, max: kLevelMax, minOut: kLevelMin, maxOut: kLevelMax)
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageSharpenFilter: Sharpens the image
        - sharpness: The sharpness adjustment to apply (-4.0 - 4.0, with 0.0 as the default)
     */
    let kSharpnessMin: CGFloat = -4.0
    let kSharpnessDefault: CGFloat = 0.0
    let kSharpnessMax: CGFloat = 4.0
    
    func filterSharpness(originImage: UIImage, sharpness: CGFloat) -> UIImage {
        if sharpness < kSharpnessMin {
            return originImage
        }
        if sharpness > kSharpnessMax {
            return originImage
        }
        if let filter = filterWithType(.Sharpness) as? GPUImageSharpenFilter {
            filter.sharpness = sharpness
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageVignetteFilter: Performs a vignetting effect, fading out the image at the edges
        - vignetteCenter: The center for the vignette in tex coords (CGPoint), with a default of 0.5, 0.5
        - vignetteColor: The color to use for the vignette (GPUVector3), with a default of black
        - vignetteStart: The normalized distance from the center where the vignette effect starts, with a default of 0.5
        - vignetteEnd: The normalized distance from the center where the vignette effect ends, with a default of 0.75
     */
    let kVignetteMin: CGFloat = 0.5
    let kVignetteDefault: CGFloat = 0.75
    let kVignetteMax: CGFloat = 1.0
    
    func filterVignette(originImage: UIImage, vignetteEnd: CGFloat) -> UIImage {
        if vignetteEnd < kVignetteMin {
            return originImage
        }
        if vignetteEnd > kVignetteMax {
            return originImage
        }
        if let filter = filterWithType(.Vignette) as? GPUImageVignetteFilter {
            filter.vignetteEnd = vignetteEnd
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageGammaFilter: Adjusts the gamma of an image
        - gamma: The gamma adjustment to apply (0.0 - 3.0, with 1.0 as the default)
     */
    let kGammaMin: CGFloat = 0.0
    let kGammaDefault: CGFloat = 1.0
    let kGammaMax: CGFloat = 3.0
    
    func filterGamma(originImage: UIImage, gamma: CGFloat) -> UIImage {
        if gamma < kGammaMin {
            return originImage
        }
        if gamma > kGammaMax {
            return originImage
        }
        if let filter = filterWithType(.Gamma) as? GPUImageGammaFilter {
            filter.gamma = gamma
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
        - GPUImageLookupFilter: Uses an RGB color lookup image to remap the colors in an image. 
            First, use your favourite photo editing application to apply a filter to lookup.png from GPUImage/framework/Resources. 
            For this to work properly each pixel color must not depend on other pixels (e.g. blur will not work).   
            If you need a more complex filter you can create as many lookup tables as required. Once ready, use your new lookup.png file as a second input for GPUImageLookupFilter.
     */
    let kLookupMin: CGFloat = 0.0
    let kLookupDefault: CGFloat = 1.0
    let kLookupMax: CGFloat = 1.0
    
    func filterLookup(originImage: UIImage, intensity: CGFloat) -> UIImage {
        if intensity < kLookupMin {
            return originImage
        }
        if intensity > kLookupMax {
            return originImage
        }
        if let filter = filterWithType(.Lookup) as? GPUImageLookupFilter {
            filter.intensity = intensity
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
     - GPUImageMonochromeFilter: Converts the image to a single-color version, based on the luminance of each pixel
     - intensity: The degree to which the specific color replaces the normal image color (0.0 - 1.0, with 1.0 as the default)
     - color: The color to use as the basis for the effect, with (0.6, 0.45, 0.3, 1.0) as the default.
     */
    let kIntensityMin: CGFloat = 0.0
    let kIntensityDefault: CGFloat = 1.0
    let kIntensityMax: CGFloat = 1.0
    let kMonoChromeColorDefault = GPUVector4(one: 0.6, two: 0.45, three: 0.3, four: 1.0)
    
    func filterMonochrome(originImage: UIImage, intensity: CGFloat) -> UIImage {
        if intensity < kIntensityMin {
            return originImage
        }
        if intensity > kIntensityMax {
            return originImage
        }
        if let filter = filterWithType(.MonoChrome) as? GPUImageMonochromeFilter {
            filter.intensity = intensity
            filter.color = kMonoChromeColorDefault
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
     GPUImageFalseColorFilter: Uses the luminance of the image to mix between two user-specified colors
     - firstColor: The first and second colors specify what colors replace the dark and light areas of the image, respectively. 
     The defaults are (0.0, 0.0, 0.5) amd (1.0, 0.0, 0.0).
     - secondColor:
     */
    let kFalseColorFirstDefault = GPUVector4(one: 0.0, two: 0.0, three: 0.5, four: 1.0)
    let kFalseColorSecondDefault = GPUVector4(one: 1.0, two: 0.0, three: 0.0, four: 1.0)
    
    func filterFalseColor(originImage: UIImage, firstColor: GPUVector4, secondColor: GPUVector4) -> UIImage {
        if let filter = filterWithType(.FalseColor) as? GPUImageFalseColorFilter {
            filter.firstColor = firstColor
            filter.secondColor = secondColor
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
     GPUImageHazeFilter: Used to add or remove haze (similar to a UV filter)
     - distance: Strength of the color applied. Default 0. Values between -.3 and .3 are best.
     - slope: Amount of color change. Default 0. Values between -.3 and .3 are best.
     */
    let kDistanceMin: CGFloat = -3.0
    let kDistanceDefault: CGFloat = 0.0
    let kDistanceMax: CGFloat = 3.0
    
    let kSlopeMin: CGFloat = -3.0
    let kSlopeDefault: CGFloat = 0.0
    let kSlopeMax: CGFloat = 3.0
    
    func filterHaze(originImage: UIImage, distance: CGFloat, slope: CGFloat) -> UIImage {
        if distance < kDistanceMin {
            return originImage
        }
        if distance > kDistanceMax {
            return originImage
        }
        if slope < kSlopeMin {
            return originImage
        }
        if slope > kSlopeMax {
            return originImage
        }
        if let filter = filterWithType(.Haze) as? GPUImageHazeFilter {
            filter.distance = distance
            filter.slope = slope
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
     GPUImageOpacityFilter: Adjusts the alpha channel of the incoming image
     opacity: The value to multiply the incoming alpha channel for each pixel by (0.0 - 1.0, with 1.0 as the default)
     */
    let kOpacityMin: CGFloat = 0.0
    let kOpacityDefault: CGFloat = 1.0
    let kOpacityMax: CGFloat = 1.0
    
    func filterOpacity(originImage: UIImage, opacity: CGFloat) -> UIImage {
        if opacity < kOpacityMin {
            return originImage
        }
        if opacity > kOpacityMax {
            return originImage
        }
        if let filter = filterWithType(.Opacity) as? GPUImageOpacityFilter {
            filter.opacity = opacity
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
     GPUImageSolidColorGenerator: This outputs a generated image with a solid color. 
     You need to define the image size using -forceProcessingAtSize:
     color: The color, in a four component format, that is used to fill the image.
     */
    func filterSolidColor(originImage: UIImage, color: GPUVector4) -> UIImage {
        if let filter = filterWithType(.SolidColor) as? GPUImageSolidColorGenerator {
            filter.color = color
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    /*
     GPUImageChromaKeyFilter: For a given color in the image, sets the alpha channel to 0. 
     This is similar to the GPUImageChromaKeyBlendFilter, only instead of blending in a second image for a matching color this doesn't take in a second image and just turns a given color transparent.
     thresholdSensitivity: How close a color match needs to exist to the target color to be replaced (default of 0.4)
     smoothing: How smoothly to blend for the color match (default of 0.1)
     */
    let kThresholdSensitivityMin: CGFloat = 0.0
    let kThresholdSensitivityDefault: CGFloat = 0.4
    let kThresholdSensitivityMax: CGFloat = 1.0
    
    let kSmoothingMin: CGFloat = 0.0
    let kSmoothingDefault: CGFloat = 0.1
    let kSmoothingMax: CGFloat = 1.0
    
    func filterChromaKey(originImage: UIImage, thresholdSensitivity: CGFloat, smoothing: CGFloat) -> UIImage {
        if thresholdSensitivity < kThresholdSensitivityMin {
            return originImage
        }
        if thresholdSensitivity > kThresholdSensitivityMax {
            return originImage
        }
        if smoothing < kSmoothingMin {
            return originImage
        }
        if smoothing > kSmoothingMax {
            return originImage
        }
        if let filter = filterWithType(.ChromaKey) as? GPUImageChromaKeyFilter {
            filter.thresholdSensitivity = thresholdSensitivity
            filter.smoothing = smoothing
            return filter.imageByFilteringImage(originImage)
        }
        return originImage
    }
    
    private func filterWithType(type: AdjustmentType) -> GPUImageOutput? {
        var filter: GPUImageOutput?
        switch type {
        case .Brightness:
            filter = GPUImageBrightnessFilter()
            break
        case .Contrast:
            filter = GPUImageContrastFilter()
            break
        case .Temperature:
            filter = GPUImageWhiteBalanceFilter()
            break
        case .Exposure:
            filter = GPUImageExposureFilter()
            break
        case .HighlightShadow:
            filter = GPUImageHighlightShadowFilter()
            break
        case .Saturation:
            filter = GPUImageSaturationFilter()
            break
        case .RGB:
            filter = GPUImageRGBFilter()
            break
        case .Hue:
            filter = GPUImageHueFilter()
            break
        case .Level:
            filter = GPUImageLevelsFilter()
            break
        case .Sharpness:
            filter = GPUImageSharpenFilter()
            break
        case .Vignette:
            filter = GPUImageVignetteFilter()
            break
        case .Gamma:
            filter = GPUImageGammaFilter()
            break
        case .Lookup:
            filter = GPUImageLookupFilter()
            break
        case .MonoChrome:
            filter = GPUImageMonochromeFilter()
            break
        case .FalseColor:
            filter = GPUImageFalseColorFilter()
            break
        case .Haze:
            filter = GPUImageHazeFilter()
            break
        case .Opacity:
            filter = GPUImageOpacityFilter()
            break
        case .SolidColor:
            filter = GPUImageSolidColorGenerator()
            break
        case .ChromaKey:
            filter = GPUImageChromaKeyFilter()
            break
        }
        return filter
    }

    
}
