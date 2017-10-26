//
//  DatePickerView.swift
//  DinoWeiBo
//
//  Created by liu yao on 2017/4/6.
//  Copyright © 2017年 深圳多诺信息科技有限公司. All rights reserved.
//

import UIKit

private let mycommonEdge: CGFloat = 13
private let mylableSize: CGFloat = 15//设置常用字体大小为16
private let bordertopbottom:CGFloat = 4 //borderview的上下编剧
private let commonCellHeight = CGFloat(37.0 + 6)//常用tableCell的高度
private let popViewH = CGFloat(23)//底部弹窗view的高度
private let listlitalImgW:CGFloat = 18//列表小图标的宽度


/// 日期选择器 - 年 月 日
class DatePickerView: UIView {
    
    var canButtonReturnB: (() -> Void)? //取消按钮的回调
    
    var sucessReturnB: ((_ date:String) -> Void)?//选择的回调
    
    //MARK:按钮的点击
    func buttonClick(_ sender:UIButton) {
        QL2("======取消按钮被点击=====")
        switch sender.tag {
        case 101:
            if self.canButtonReturnB != nil {
                self.canButtonReturnB!()
            }
        case 102:
            if self.sucessReturnB != nil {
                let currentDate = datePicker.date
                let dateStr = dateFormatter.string(from: currentDate)
                self.sucessReturnB!(dateStr)
            }
        default:
            break
        }
    }

    // MARK: - 设置UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: kScreenH - 256, width: kScreenW, height: 256))
        setupUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        addTitle()
        addCancelButton()
        addLineView()
        addConfirmButton()
        addDataPicker()
    }
    private func addTitle() {
        addSubview(title)
        title.textColor = myBlackColr
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 15.0)
        title.snp.makeConstraints { (make) in
            make.top.equalTo(mycommonEdge)
            make.centerX.equalTo(self.snp.centerX)
            
        }
    }
    private func addCancelButton() {
        addSubview(cancelButton)
        cancelButton.setTitleColor(UIColor.system, for: .normal)
        cancelButton.tag = 101
        cancelButton.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(mycommonEdge)
            make.left.equalTo(mycommonEdge)
            make.size.equalTo(CGSize(width: 40, height: mylableSize))
        }
    }
    private func addLineView() {
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(cancelButton.snp.bottom).offset(mycommonEdge)
            make.height.equalTo(1)
            make.leading.trailing.equalTo(self)
        }
    }
    private func addConfirmButton() {
        addSubview(confirmButton)
        confirmButton.setTitleColor(UIColor.system, for: .normal)
        confirmButton.tag = 102
        confirmButton.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        confirmButton.snp.makeConstraints { (make) in
            make.top.equalTo(mycommonEdge)
            make.right.equalTo(-mycommonEdge)
            make.size.equalTo(CGSize(width: 40, height: mylableSize))
        }
    }
    private func addDataPicker() {
        addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalTo(self)
        }
    }
    
    // MARK: - 懒加载
    private lazy var title: UILabel = UILabel(title: "选择时间")
    private lazy var cancelButton = UIButton(title: "取消", bgColor: UIColor.clear, font: 15.0)
    private lazy var confirmButton = UIButton(title: "确定", bgColor: UIColor.clear, font: 15.0)
    private lazy var lineView: UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.systemGray
        return v
    }()
    private lazy var dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "en")
        return df
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
}
