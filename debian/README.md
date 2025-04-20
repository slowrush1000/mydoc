# install graphic driver
```
% sudo apt install nvidier_driver
% sudo nvidia-settings
```

# install vim plugin(bundle)
    https://khd0801.com/entry/vim-Vundle%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-Plugin-%EC%84%A4%EC%B9%98 

# install vscode 
    https://code.visualstudio.com/docs/setup/linux#_install-vs-code-on-linux

# install web-browser
    https://repo.whale.naver.com/
    chrome browser

# install google drive
    install google-drive-ocamlfuse in Debian
        https://www.linuxbabe.com/cloud-storage/install-google-drive-ocamlfuse-ubuntu-linux-mint
    use google-drive-ocamlfuse
        https://www.geeksforgeeks.org/how-to-use-google-drive-in-linux/
    deb 파일을 찾아서 설치할 것!
```
% google-drive-ocamlfuse -id slowrush1@gmail.com -secret fastrush1000 google_drive
```

# install nave-whale
    https://repo.whale.naver.com/
```
% sudo wget -q -O - http://repo.whale.naver.com/stable/deb/public.gpg | sudo tee /etc/apt/trusted.gpg.d/naver-whale.asc
```

# install anaconda
```
    conda config --set auto_activate_base false
```