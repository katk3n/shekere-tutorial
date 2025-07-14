# Shekere Shader Art Tutorial
## shekereフレームワークを使ったシェーダーアート学習コンテンツ

このリポジトリは、クリエイティブコーディングフレームワーク **shekere** を使用して、シェーダーアートの作成方法を段階的に学習できるチュートリアルコンテンツです。

---

## 🎯 学習目標

シェーダーアート初学者が以下のスキルを習得することを目標としています：

- **WGSL（WebGPU Shading Language）**の基礎
- **shekereフレームワーク**の活用方法
- **リアルタイムグラフィックス**の理論と実践
- **音響ビジュアル連携**技術
- **クリエイティブコーディング**手法

---

## 📚 学習コンテンツ

### Phase 1: 基礎編
- **[Chapter 1: Hello Shader World](./chapter-01/)** - シェーダーの基本、色、座標系
- **[Chapter 2: Time and Animation](./chapter-02/)** - 時間ベースアニメーション、sin/cos関数
- **[Chapter 3: Coordinates and Patterns](./chapter-03/)** - 座標系と幾何学パターン

### Phase 2: 応用編（予定）
- **Chapter 4: Interaction** - マウス・キーボード入力
- **Chapter 5: Audio Visualization** - 音響ビジュアライゼーション
- **Chapter 6: MIDI Control** - MIDI機器との連携
- **Chapter 7: Advanced Patterns** - 高度なパターン技法

### Phase 3: 上級編（予定）
- **Chapter 8: Multi-Pass Rendering** - マルチパス・レンダリング
- **Chapter 9: Performance Optimization** - パフォーマンス最適化
- **Chapter 10: Creative Project** - 総合作品制作

---

## 🛠️ 前提環境

### 必要なソフトウェア
- **Rust**: shekereのインストールに必要
- **shekere**: 本フレームワーク

### インストール方法
```bash
# Rustのインストール（未インストールの場合）
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# shekereのインストール
cargo install shekere

# または、GitHubのReleasesからバイナリをダウンロード
# https://github.com/katk3n/shekere/releases
```

### 前提知識
- プログラミングの基礎経験（言語不問）
- 基本的な数学知識（三角関数、ベクトル）
- コンピューターグラフィックスへの興味

---

## 🚀 学習の始め方

1. **環境構築**: 上記のインストール手順に従ってshekereをセットアップ
2. **Chapter 1から開始**: [chapter-01](./chapter-01/)フォルダのREADME.mdを読む
3. **段階的学習**: 各章を順番に進める
4. **実践重視**: サンプルコードを実行し、演習課題に取り組む

---

## 📁 プロジェクト構造

```
shekere-tutorial/
├── README.md                    # このファイル
├── CLAUDE.md                    # 学習コンテンツ戦略書
├── chapter-01/                  # Chapter 1: Hello Shader World
│   ├── README.md               # 理論解説とガイド
│   ├── examples/               # サンプルプロジェクト
│   ├── exercises/              # 演習課題
│   └── solutions/              # 解答例
├── chapter-02/                  # Chapter 2以降も同様の構成
├── chapter-03/                  # ...
└── resources/                   # 共通リソース（予定）
```

---

## 🎨 シェーダーアートについて

**シェーダーアート**は、GPU上で動作するシェーダープログラムを使用して作成される芸術作品です。数学的な美しさとリアルタイム性を特徴とし、以下の分野で活用されています：

- **VJパフォーマンス**: ライブ音楽イベントでの映像演出
- **デジタルアート**: インタラクティブな芸術作品
- **ゲーム開発**: 特殊効果やビジュアルエンハンス
- **インスタレーション**: 美術館・ギャラリーでの展示

---

## 🔗 関連リンク

- **[shekere公式リポジトリ](https://github.com/katk3n/shekere)**: フレームワークの詳細情報
- **[WebGPU仕様](https://www.w3.org/TR/webgpu/)**: WGSLの技術仕様
- **[Shadertoy](https://www.shadertoy.com/)**: シェーダーアート作品の参考
