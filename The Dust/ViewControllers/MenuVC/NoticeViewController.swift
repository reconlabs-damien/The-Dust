//
//  NoticeViewController.swift
//  The Dust
//
//  Created by Jun on 2020/11/18.
//

import UIKit

class NoticeViewController: UIViewController {

    @IBOutlet weak var serviceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serviceLabel.numberOfLines = 0
        self.serviceLabel.text = """
            안녕하세요, \n
            The Dust 운영자 입니다. \n\n
            The Dust 서비스가 1.0버전으로 처음 출시되었습니다. \n
            1. 1.0 출시 일시 : 2020년 11월 20일 금요일 \n
            2. 주요기능 \n
            - 실시간 미세먼지 조회 \n
            - 공기 지도 조회 \n
            - 캐릭터 중심의 UI 적용 \n\n
            
            The Dust 앱 버전은 [설정 > 앱 정보]에서 확인하실 수 있습니다.
        """
    }

}
