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

### Phase 2: 応用編
- **[Chapter 4: Interaction](./chapter-04/)** - マウス・キーボード入力
- **[Chapter 5: Audio Visualization](./chapter-05/)** - 音響ビジュアライゼーション
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
4. **作品制作アプローチ**: 演習課題では1つの作品を段階的に完成させる形式で学習

---

## 📁 プロジェクト構造

```
shekere-tutorial/
├── README.md                    # このファイル
├── CLAUDE.md                    # 学習コンテンツ戦略書
├── chapter-01/                  # Chapter 1: Hello Shader World
│   ├── README.md               # 理論解説とガイド
│   ├── examples/               # サンプルプロジェクト
│   │   ├── 01-solid-color/
│   │   ├── 02-gradient/
│   │   └── 03-uv-visualization/
│   └── exercises/              # 段階的作品制作演習
│       ├── 01-basic-circle/        # ステップ1: 基本の円を描く
│       ├── 02-concentric-circles/  # ステップ2: 同心円パターン
│       ├── 03-radial-pattern/      # ステップ3: 放射状パターン
│       └── 04-final-polish/        # ステップ4: 最終調整（完成）
├── chapter-02/                  # Chapter 2: Time and Animation
│   └── exercises/
│       ├── 01-static-patterns/     # ステップ1: 静止パターンの作成
│       ├── 02-time-animation/      # ステップ2: 基本時間アニメーション
│       ├── 03-complex-time-effects/ # ステップ3: 複雑時間効果
│       └── 04-final-spiral-artwork/ # ステップ4: 最終螺旋作品
├── chapter-03/                  # Chapter 3: Coordinates and Patterns
│   └── exercises/
│       ├── 01-basic-coordinate-transformations/ # ステップ1: 基本座標変換
│       ├── 02-distance-and-angle-patterns/      # ステップ2: 距離・角度パターン
│       ├── 03-multi-layer-petals/              # ステップ3: 多層花びらパターン
│       └── 04-final-flower-artwork/            # ステップ4: 最終作品「花の生命力」
├── chapter-04/                  # ...
├── chapter-05/                  # ...
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
