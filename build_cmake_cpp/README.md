# T_PROJECT

## dev_20250419.0.0

### CMakeLists.txt 예제
```
cmake_minimum_required(VERSION 3.20)
project(libspf VERSION 1.0.0 LANGUAGES CXX)

set(PROJECT_NAME  "libspf")
set(PROGRAM_NAME  "spf")

# Location of additional cmake modules
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" "${CMAKE_MODULE_PATH}")

# ycm
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# c++ standard : 20
set(CMAKE_CXX_STANDARD          20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# directory setting
set(EXTERN_DIR                  "/media/PROJECT02/extern")
set(INSTALL_DIR                 "${EXTERN_DIR}/${PROJECT_NAME}")

# source/include directories
set(PROJECT_SRC_DIR             "${CMAKE_SOURCE_DIR}/src")
set(PROJECT_INC_DIR             "${CMAKE_SOURCE_DIR}/include")

# ctags : make ctags
add_custom_target(ctags ALL
    COMMENT "Generate tags file with ctags"
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMAND ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ${CMAKE_SOURCE_DIR}
    COMMAND cp -f tags ${CMAKE_SOURCE_DIR}/src
)

# clangformat : make clang-format
add_custom_target(clang-format ALL
    COMMENT "Format source codes"
    COMMAND /usr/bin/clang-format -i ${CMAKE_SOURCE_DIR}/src/*.cpp
    COMMAND /usr/bin/clang-format -i ${CMAKE_SOURCE_DIR}/include/*.hpp
)

#
add_subdirectory(src)
add_subdirectory(test)
add_subdirectory(docs)
```


### vscode offline 설치
1. vscode offline 설인터넷이 연결되지 않은 컴퓨터에 Visual Studio Code (VS Code)를 설치하는 방법은 다음과 같습니다. 기본적으로 인터넷이 연결된 다른 컴퓨터에서 필요한 파일들을 다운로드하여 이동식 저장 장치(USB 드라이브 등)를 통해 설치해야 합니다.

단계별 방법:

1. 인터넷이 연결된 컴퓨터에서 필요한 파일 다운로드:

Visual Studio Code 설치 파일 다운로드:

인터넷이 연결된 컴퓨터의 웹 브라우저를 열고 VS Code 공식 웹사이트 (https://code.visualstudio.com/)로 이동합니다.
다운로드 페이지에서 해당 컴퓨터의 운영체제(Windows, macOS, Linux)에 맞는 설치 파일을 다운로드합니다. 일반적으로 .exe (Windows), .dmg (macOS), .deb 또는 .rpm (Linux) 형식입니다.
팁: "User Installer" 또는 "System Installer" 중 필요에 맞는 버전을 선택하세요. 사용자 설치 프로그램은 현재 사용자 계정에만 설치되고, 시스템 설치 프로그램은 모든 사용자에게 설치됩니다.
필요한 추가 종속성 (선택 사항):

VS Code 자체는 기본적인 기능만 포함하고 있습니다. 특정 프로그래밍 언어 지원, 디버깅 도구, 린터(Linter), 포매터(Formatter) 등의 추가 기능을 사용하려면 해당 확장(Extensions)을 설치해야 합니다.
어떤 확장 기능이 필요한지 미리 알고 있다면, 인터넷이 연결된 컴퓨터에서 해당 확장 기능을 다운로드할 수 있습니다.
VS Code Marketplace (https://marketplace.visualstudio.com/vscode) 웹사이트로 이동합니다.
필요한 확장 기능을 검색하고 해당 확장 기능의 상세 페이지로 들어갑니다.
확장 기능 상세 페이지에서 "Download Extension" 링크를 찾아 .vsix 형식의 파일을 다운로드합니다.
필요한 런타임 환경 (선택 사항):

개발하려는 특정 프로그래밍 언어에 필요한 런타임 환경(예: Python, Node.js, Java Development Kit - JDK)이 설치되어 있지 않다면, 해당 런타임 환경의 설치 파일도 인터넷이 연결된 컴퓨터에서 다운로드해야 합니다. 각 언어의 공식 웹사이트에서 다운로드할 수 있습니다.
2. 이동식 저장 장치로 파일 복사:

다운로드한 VS Code 설치 파일, 확장 파일(.vsix), 그리고 필요한 런타임 환경 설치 파일을 USB 드라이브와 같은 이동식 저장 장치에 복사합니다.
3. 인터넷이 없는 컴퓨터에 파일 설치:

이동식 저장 장치를 인터넷이 없는 컴퓨터에 연결합니다.
이동식 저장 장치에서 VS Code 설치 파일(예: .exe)을 찾아 실행합니다.
화면에 나타나는 설치 지침에 따라 VS Code를 설치합니다.
4. 확장 기능 설치 (선택 사항):

VS Code를 실행합니다.
사이드바의 확장 (Extensions) 아이콘을 클릭하거나 Ctrl+Shift+X (Windows/Linux) 또는 Cmd+Shift+X (macOS) 단축키를 누릅니다.
확장 뷰의 상단에 있는 "..." (More Actions) 메뉴를 클릭하고 "Install from VSIX..." 를 선택합니다.
파일 탐색기 창이 열리면 이동식 저장 장치에 복사해 둔 .vsix 확장 파일들을 선택하고 "Install" 버튼을 클릭하여 설치합니다. 필요한 모든 확장 기능을 같은 방법으로 설치합니다.
5. 런타임 환경 설치 (선택 사항):

개발하려는 언어에 필요한 런타임 환경 설치 파일(예: Python 설치 파일, Node.js 설치 파일)을 이동식 저장 장치에서 찾아 실행합니다.
화면에 나타나는 설치 지침에 따라 런타임 환경을 설치합니다.
주의사항:

VS Code와 확장 기능은 지속적으로 업데이트될 수 있습니다. 최신 기능을 사용하거나 보안 취약점을 해결하려면 주기적으로 인터넷이 연결된 환경에서 최신 버전을 다운로드하여 업데이트해야 합니다.
확장 기능 간의 호환성 문제가 발생할 수 있습니다. 인터넷이 연결된 환경에서 미리 필요한 확장 기능들을 테스트해 보는 것이 좋습니다.
일부 확장 기능은 인터넷 연결을 필요로 하는 특정 기능(예: 온라인 문서 접근, 라이선스 확인 등)을 포함할 수 있습니다. 이러한 기능은 인터넷이 없는 환경에서 작동하지 않을 수 있습니다.
위 단계를 따르면 인터넷이 연결되지 않은 컴퓨터에도 Visual Studio Code를 설치하고 필요한 개발 환경을 구성할 수 있습니다.치


## dev_20230422.0.0
1. change setter/getter format
    set_name, name
2. add k_source_dir in yh::util
3. update unit test code

## dev_20230419.0.0
1. change project structure
    1. (C++ Project Structure and Cross-Platform Build With CMake)[https://medium.com/swlh/c-project-structure-for-cmake-67d60135f6f5]

## dev_20230409.0.0
1. add .clang-format, .gitignore
2. add vscode's settings.json
