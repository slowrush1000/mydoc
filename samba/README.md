# samba 설정방법

윈도우 11 Home 버전이 설치된 컴퓨터의 파일을 읽고 쓸 수 있도록 리눅스 컴퓨터에 Samba 서버를 설치하는 방법에 대한 안내입니다. 이전 답변과 유사하지만, 읽고 쓰기 권한을 명확히 강조하여 설명드리겠습니다.

1. Samba 서버 설치:

리눅스 배포판에 맞는 명령어를 사용하여 Samba 서버 패키지를 설치합니다.

Debian/Ubuntu 계열:

Bash

sudo apt update
sudo apt install samba samba-common-bin
Fedora/CentOS/RHEL 계열:

Bash

sudo dnf install samba samba-common
sudo systemctl start smb nmb
sudo systemctl enable smb nmb

2. Samba 설정 파일 수정:

/etc/samba/smb.conf 파일을 편집하여 공유할 폴더와 읽기/쓰기 권한을 설정합니다.

Bash

sudo nano /etc/samba/smb.conf
파일 하단에 공유 설정을 추가합니다. 예를 들어, /home/사용자이름/공유폴더를 공유하고 윈도우 사용자가 읽고 쓸 수 있도록 설정하려면 다음과 같이 추가합니다.

Ini, TOML

[공유이름]
   comment = 윈도우 공유 폴더
   path = /home/사용자이름/공유폴더
   browsable = yes
   writable = yes
   guest ok = no
   valid users = 사용자이름
각 항목에 대한 설명은 다음과 같습니다.

[공유이름]: 윈도우 탐색기에 표시될 공유 폴더 이름입니다. (예: my_shared_folder)
comment: 공유 폴더에 대한 설명 (선택 사항).
path: 실제로 공유할 리눅스 폴더의 경로입니다. 반드시 실제 공유하려는 폴더 경로로 변경하세요.
browsable = yes: 윈도우 네트워크 환경에서 공유 폴더가 보이도록 설정합니다.
writable = yes: 윈도우 사용자가 이 공유 폴더에 파일을 생성, 수정, 삭제할 수 있도록 쓰기 권한을 부여합니다.
guest ok = no: 게스트 접근을 비활성화하고, valid users에 지정된 사용자만 접근하도록 합니다. 보안을 위해 no로 설정하는 것이 좋습니다.
valid users = 사용자이름: 이 공유 폴더에 접근할 수 있는 리눅스 사용자 계정입니다. 실제 리눅스 사용자 이름으로 변경해야 합니다. 여러 사용자를 지정하려면 쉼표로 구분합니다.
3. Samba 사용자 계정 설정:

Samba는 리눅스 시스템 계정과 별도의 비밀번호를 사용할 수 있습니다. valid users에 지정한 리눅스 사용자에 대해 Samba 비밀번호를 설정해야 윈도우에서 접근할 수 있습니다.

Bash

sudo smbpasswd -a 사용자이름
사용자이름은 smb.conf 파일의 valid users에 설정한 리눅스 계정 이름입니다. 명령어를 실행하면 해당 사용자의 Samba 비밀번호를 설정하라는 메시지가 나타납니다. 비밀번호를 입력하고 확인합니다.

4. 공유 폴더 권한 확인:

공유하려는 리눅스 폴더에 대해 해당 리눅스 사용자가 읽고 쓰기 권한을 가지고 있는지 확인해야 합니다. 예를 들어, /home/사용자이름/공유폴더의 권한을 확인하려면 다음과 같이 실행합니다.

Bash

ls -l /home/사용자이름/공유폴더
출력 결과에서 해당 사용자에게 읽기 (r) 및 쓰기 (w) 권한이 있는지 확인합니다. 필요하다면 chmod 명령어를 사용하여 권한을 변경할 수 있습니다.

5. Samba 서비스 재시작:

설정을 변경했으므로 Samba 서비스를 재시작하여 변경 사항을 적용합니다.

Bash

sudo systemctl restart smbd nmb

6. 방화벽 설정:

리눅스 시스템의 방화벽이 활성화되어 있다면 Samba 트래픽을 허용해야 합니다.

firewalld를 사용하는 경우:

Bash

sudo firewall-cmd --permanent --add-service=samba
sudo firewall-cmd --reload
ufw를 사용하는 경우 (Ubuntu 기본 방화벽):

Bash

sudo ufw allow samba
sudo ufw enable

7. 윈도우 11 Home에서 접근:

이제 윈도우 11 Home 컴퓨터에서 리눅스 Samba 공유 폴더에 접근하여 파일을 읽고 쓸 수 있습니다.

윈도우 탐색기를 엽니다.
주소창에 리눅스 컴퓨터의 IP 주소 또는 호스트 이름을 \\리눅스_IP_주소\ 또는 \\리눅스_호스트이름\ 형식으로 입력하고 Enter 키를 누릅니다. (예: \\192.168.1.100\ 또는 \\mylinuxserver\)
설정한 공유 이름 ([공유이름]에 지정한 이름)이 보일 것입니다.
접근 시 사용자 이름과 비밀번호를 묻는 창이 나타나면 설정한 리눅스 사용자 이름과 Samba 비밀번호를 입력합니다. "자격 증명 기억" 옵션을 선택하면 다음부터는 자동으로 접속될 수 있습니다.
이제 윈도우 11 Home 컴퓨터에서 리눅스 시스템의 공유 폴더에 파일을 자유롭게 읽고 쓸 수 있습니다. 설정 과정에서 오류가 발생하면 설정 파일을 다시 확인하고 Samba 서비스 상태를 점검해 보세요. 궁금한 점이 있으시면 언제든지 다시 질문해 주세요!