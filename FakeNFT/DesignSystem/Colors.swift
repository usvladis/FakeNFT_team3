import UIKit

extension UIColor {
    
    static var blackUniversal: UIColor { #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1) }
    static var whiteUniversal: UIColor { #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    static var lightGrayDay: UIColor { #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.9725490196, alpha: 1) }
    static var lightGrayNight: UIColor { #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1803921569, alpha: 1) }
    static var grayUniversal: UIColor { #colorLiteral(red: 0.3843137255, green: 0.3607843137, blue: 0.3607843137, alpha: 1) }
    static var redUniversal: UIColor { #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1) }
    static var backgroundUniversal: UIColor { #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 0.5) }
    static var greenUniversal: UIColor { #colorLiteral(red: 0.1098039216, green: 0.6235294118, blue: 0, alpha: 1) }
    static var blueUniversal: UIColor { #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1) }
    static var yellowUniversal: UIColor { #colorLiteral(red: 0.9960784314, green: 0.937254902, blue: 0.05098039216, alpha: 1) }
    static var bordersColor: UIColor { #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.36) }
    static var alertBackgroundColor: UIColor { #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 0.8) }
    static var catalogBackgroundDark: UIColor { #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1294117647, alpha: 1) }
    
    static var catalogBackgroundColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
                .catalogBackgroundDark   :  // Цвет для тёмной темы
                .whiteUniversal  // Цвет для светлой темы
        }
    }
    
    
    static var backgroudColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
                .blackUniversal   :  // Цвет для тёмной темы
                .whiteUniversal  // Цвет для светлой темы
        }
    }
    
    static var fontColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
                .whiteUniversal   :  // Цвет для тёмной темы
                .blackUniversal  // Цвет для светлой темы
        }
    }
    
    static var buttonColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
                .whiteUniversal   :  // Цвет для тёмной темы
                .blackUniversal  // Цвет для светлой темы
        }
    }
    
    static var greyColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
                .lightGrayNight   :  // Цвет для тёмной темы
                .lightGrayDay  // Цвет для светлой темы
        }
    }
    
    static var sortCellBackgroundColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 0.7)   :  // Цвет для тёмной темы
            #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 0.7)  // Цвет для светлой темы
        }
    }
    
    static var fontSortColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9607843137, alpha: 0.6)   :  // Цвет для тёмной темы
            #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)  // Цвет для светлой темы
        }
    }
    
    static var estimationBackgroundColor: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1176470588, alpha: 0.75)   :  // Цвет для тёмной темы
            #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 0.75)  // Цвет для светлой темы
        }
    }
}

