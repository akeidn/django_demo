# 本机 ACS 助手说明

公网网页不能直接加载 `ACS.SPiiPlusNET.dll`，也不能直接访问用户电脑上的硬件。要实现“用户打开网站，点击连接 ACS，就连接自己电脑上的 ACS”，每台连接 ACS 控制器的电脑都需要安装一次本机 ACS 助手。

安装完成后，助手会在用户登录 Windows 时自动启动，并监听：

```text
http://127.0.0.1:5055
```

公网网页点击 `连接ACS` 时，会请求用户自己电脑上的这个本机地址，再由助手调用 `ACS.SPiiPlusNET` 控制本机 ACS。

## 开发者打包

```powershell
cd F:\project\codex\django_demo\acs-bridge
.\scripts\publish_windows.ps1
```

## 用户安装

```powershell
cd F:\project\codex\django_demo\acs-bridge
.\scripts\install_local_acs_bridge.ps1
```

安装后测试：

```powershell
Invoke-WebRequest http://127.0.0.1:5055/api/acs/status -UseBasicParsing
```

## 用户卸载

```powershell
cd F:\project\codex\django_demo\acs-bridge
.\scripts\uninstall_local_acs_bridge.ps1
```

## 注意

- 第一次安装仍然是必要的，浏览器出于安全原因不能自动安装本机硬件驱动或后台程序。
- 助手只监听 `127.0.0.1`，不会直接暴露到公网。
- 如果网站启用正式 HTTPS 域名，需要把该域名加入 `Program.cs` 的 CORS 白名单。
