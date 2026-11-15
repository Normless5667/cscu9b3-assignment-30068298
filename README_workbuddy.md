# Hospital Asset & Maintenance Internal Control System

CSCU9B3 数据库作业（学号 30068298）— 场景、数据、SQL、ERD、IEEE 报告源码全部就位。

## 目录结构

```
CSCU9B3-Database-Assignment/
├── data/
│   ├── department.csv        10 rows
│   ├── supplier.csv          10 rows
│   ├── asset.csv             12 rows
│   └── maintenance_log.csv   15 rows (复合主键 asset_tag + service_no)
├── sql/
│   ├── schema.sql            CREATE TABLE x4 + LOAD DATA + 每实体 1 条 INSERT
│   └── queries.sql           作业要求的 6 条查询(带业务解释注释)
├── docs/
│   ├── report_main.tex       报告源码(16 节 + 附录 A/B/C，Overleaf 编译)
│   ├── report_preview.pdf    ★ 早期草稿的单栏预览，内容已过期，勿作提交版
│   ├── report_preview.html   上述预览的 HTML 源(同样过期)
│   ├── erd.html              ER 图交互预览(浏览器打开)
│   ├── figures/erd.png       2x 分辨率 ER 图 PNG (报告 Figure 1 已引用)
│   ├── figures/erd_fig.html  截图用的纯净版 SVG 页面
│   ├── figures/erd_raw.png   原始截图(含页面标题)
│   ├── normalization-notes.md    范式讨论要点
│   └── complexity-discussion.md  复杂性讨论要点
├── SKILL.md                  项目交接文档(状态/验证事实/迭代约定)
└── README.md
```

## 报告结构（report_main.tex）

| 节 | 内容 |
|----|------|
| I | Introduction |
| II | Scenario and Requirements（含需求获取、业务规则、需求追溯表）|
| III | Conceptual Design: the ER Model（含复合主键论证、参与度论证）|
| IV | Logical Design and Normalisation（逐范式论证 + BCNF）|
| V | Design Alternatives Considered（代理键/拆表/派生数据三条被否方案）|
| VI | Physical Implementation（数据类型、DDL、装载、数据字典、约束验证、装载踩坑）|
| VII | The Query Suite（Q1–Q6 各配业务动机 + 真实结果表）|
| VIII | Verification and Testing（12 条测试记录）|
| IX | Indexes and Execution Plans（真实 EXPLAIN 输出）|
| X | Complexity Discussion |
| XI | Reflection（含 Limitations）|
| XII | Professional, Ethical and Legal Considerations |
| XIII | Conclusion（含 Future work）|
| App. A | 原始数据四表 |
| App. B | 完整查询输出（Q2 13 行 / Q5 4 行 / Q6 16 行）|
| App. C | 完整 DDL 脚本 |

## 验证状态

- **SQL 已在真实 MySQL 8.4.9 上跑通**：建表 → CSV 导入（各表 11/11/13/16 行，含示例 INSERT）→ 6 条查询 + 5 条约束违规测试 + EXPLAIN 全部真实输出。
- 报告中的每个结果表、每条报错、每个执行计划都来自真实执行，不是手工编的。
- 静态校验通过：交叉引用闭合、环境配对、括号平衡。
- **页数硬约束：4 页以内**（Canvas 提交页原文 "4 pages maximum, Times New Roman Two-column style, main body text ≥ 9 pt"）。当前 tex 约 10 页，**必须压缩**；以 Overleaf 实际编译结果为准。

### 复跑 MySQL

```bash
# 初始化数据目录（只需一次）
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --initialize-insecure --datadir=C:/mysql_ic_data
# 启动（另开一个终端保持运行）
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --datadir=C:/mysql_ic_data --port=3307 --local-infile=1 --console
# 导入（把 schema.sql 里 INFILE 的相对路径改成 data 目录绝对路径）
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -P 3307 -u root --skip-password --local-infile=1 < sql/schema.sql
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -P 3307 -u root --skip-password hospital_ic -t < sql/queries.sql
```

## 报告编译

把 `docs/report_main.tex` + `docs/figures/` 上传 Overleaf（New Project → Upload Project），pdfLaTeX 编译即可，IEEEtran 由 Overleaf 自带。

## 你必须自己做的事（诚信要求）

1. **通读并改写报告正文**——尤其第 II、IV、X、XII 节，改成你自己的表达，保证 viva 能解释每个设计决定。
2. **核对两处场景叙述**（第 II-D 节需求获取）：实习观察到的审批流程、被问过的问题，要与你实际经历一致，不一致就改。
3. **AIAS 封面表如实申报** AI 使用情况。
4. **正式 ERD 用 draw.io 重画**，导出 PNG 替换 `figures/erd.png`，Proof of Process 留 GitHub/OneDrive 历史。
5. 提交：Canvas 分两处上传——① 报告 PDF 单独交（**不许打包**）；② appendix 文件夹（报告源文件 + SQL 代码 + 数据）。文件名带学号，**全文无姓名**。
6. 截止 2026-11-20 16:00，迟交每天扣 3 分。

## 待确认清单

1. 场景和 4 个实体是否符合你实习时见到的内控业务？
2. 样例数据够不够真实（科室名、价格量级、维保情景）？
3. 编译后的实际页数是否 ≤ 4？超了要砍（优先砍附录 A 原始数据、第 V 节 Alternatives、第 VIII 节测试细节）。
4. 参考文献 5 条是通用教材/文档，如老师指定引用格式请替换。
