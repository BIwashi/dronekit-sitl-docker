
# venv
## 新しい環境作成

```zsh
$ cd [project dir]
$ python3 -m venv [newenvname]
# 名前はvenvにするのが無難
```
## Activate

```zsh
$ source [newenvname]/bin/activate
```
## 環境にインストールされているパッケージ確認

```zsh
$ pip freeze
```

## Deactivate

```zsh
$ deactivate
```
---

# requirement.txtでinstall
```zsh
$ pip install -r requirements.txt
```