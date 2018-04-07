import Foundation

public class ASLEye: NSObject {
    private var timer: Timer?

    public func close() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func open(with interval:TimeInterval) {
        self.timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: #selector(ASLEye.pollingLogs),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func pollingLogs() {
        //TODO 调用拉取数据API，获得数据数组
        //TODO 判断数据数组是否为空
        //TODO 将数据数组回调给上层
    }

}
