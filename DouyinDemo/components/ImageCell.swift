import UIKit
import SDWebImage
// https://blog.csdn.net/moqj_123/article/details/73351174
class ImageCell: UICollectionViewCell {
    var imageView: UIImageView!
    func configureCell(url: String) {
//        print("absoluteString: \(url)")
        imageView.sd_setImage(with: URL(string: url))
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        self.addSubview(imageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // TODO: 为什么没有设置 imageView 的 frame 属性, 图片就像是不出来
        var frame = imageView.frame
        frame.size.height = self.frame.size.height
        frame.size.width = self.frame.size.width
        frame.origin.x = 0
        frame.origin.y = 0
        imageView.frame = frame
        imageView.contentMode = .scaleToFill
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

