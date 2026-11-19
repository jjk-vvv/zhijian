--
-- PostgreSQL database dump
--

\restrict Lwh5lrdUhGodUAAFPlHiNjQXV6lpA1rzUjbJOwUliaa9wOeUzb1VsbIKRByW2WD

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (4, 'garden', '园丁集', 'THE GARDENER', '拉宾德拉纳特·泰戈尔', '生活随笔', 160, 1913, '#b8baa0', '#334a3b', 'leaf', '把日常读成一首诗', '枕边读物', '这些短诗以花园、清晨与相遇为线索，书写细微的情绪。文字轻盈，适合分散在日常的片刻里慢慢读。', '每天只选一首，不急着解释，让它陪你走过一段平常的路。', 0.00, 0, '2026-11-12 23:37:00.846484+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (6, 'floating', '浮生六记', 'SIX RECORDS OF A FLOATING LIFE', '沈复', '生活随笔', 208, 1809, '#ded5be', '#494c39', 'mountain', '烟火人间里的小小欢喜', '日常之美', '以平实的笔触记述日常起居、游历与情感。花木、饮食和小事在字里行间展开，让普通生活也显出自己的光泽。', '留意那些关于花、茶与布置居所的小细节，日常的趣味往往就在其中。', 0.00, 0, '2026-11-12 23:37:00.848291+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (7, 'insects', '昆虫记', 'THE WORLD OF INSECTS', '让-亨利·法布尔', '自然行旅', 352, 1879, '#6c7754', '#f2e8c8', 'insect', '向微小的世界，投去好奇的目光', '自然观察', '从花园里不起眼的昆虫出发，法布尔用长期观察和生动叙述，带领读者看见微小生命的行为与生存智慧。', '读完走到户外，不必远行，你脚边的草地就有一个等待被发现的世界。', 0.00, 0, '2026-11-12 23:37:00.849514+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (9, 'pride-prejudice', '傲慢与偏见', 'PRIDE AND PREJUDICE', '简·奥斯汀', '文学小说', 416, 1813, '#8a6a5c', '#f6ecdc', 'window', '在偏见之外，重新看见彼此', '女性视角', '班纳特家的五个女儿、一场舞会与两次误解，织成一部关于婚姻、阶层与自我认识的经典喜剧。', '读对话，也读沉默。奥斯汀的锋利往往藏在礼貌的句子后面。', 0.00, 0, '2026-11-12 23:37:00.855108+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (13, 'metamorphosis', '变形记', 'THE METAMORPHOSIS', '弗朗茨·卡夫卡', '文学小说', 160, 1915, '#4d4a44', '#eee5d2', 'arch', '一觉醒来，世界换了模样', '现代寓言', '格里高尔变成甲虫后，家庭的温情迅速退潮。卡夫卡用平静的叙述，写出被日常吞没的荒诞与孤独。', '读的时候不妨想一想：真正改变他的，是身体，还是家人的目光？', 0.00, 0, '2026-11-12 23:37:00.860035+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (16, 'zarathustra', '查拉图斯特拉如是说', 'THUS SPOKE ZARATHUSTRA', '弗里德里希·尼采', '人文思考', 432, 1883, '#5b4a3a', '#f0e3c9', 'mountain', '成为你自己，是一场漫长的攀登', '思想锋芒', '借先知之口，尼采讨论超人、永恒轮回与价值重估。诗性的语言与锋利的判断交替出现，不适合被动阅读。', '不必一次读懂。把它当作一座需要反复攀登的山。', 0.00, 0, '2026-11-12 23:37:00.863629+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (17, 'republic', '理想国', 'THE REPUBLIC', '柏拉图', '人文思考', 480, -380, '#7d7562', '#f5edda', 'arch', '关于正义，一场没有终点的对话', '西方哲学源头', '苏格拉底与友人讨论正义、教育、城邦与灵魂。洞穴寓言在这里出现，至今仍在解释我们如何看见世界。', '把对话当成真实发生的争论来读，你会更容易进入其中。', 0.00, 0, '2026-11-12 23:37:00.864885+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (3, 'moon', '月亮与六便士', 'THE MOON AND SIXPENCE', '威廉·萨默塞特·毛姆', '文学小说', 288, 1919, '#344c68', '#ede8d3', 'moon', '理想与生活之间的一次远行', '关于热爱', '一个看似安稳的人突然离开熟悉的生活，去追寻绘画。故事沿着他的足迹，呈现艺术、欲望与选择的复杂面貌。', '带着问题去读：热爱可以把人带到哪里，又会让人错过什么？', 4.00, 1, '2026-11-12 23:37:00.845206+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (5, 'ownroom', '一间自己的房间', 'A ROOM OF ONE''S OWN', '弗吉尼亚·伍尔夫', '人文思考', 192, 1929, '#c47a62', '#fff3df', 'window', '为思考，留出自己的空间', '独立思考', '从写作与日常的关系出发，伍尔夫讨论创作所需要的空间、资源和自由，也邀请读者重新审视熟悉的文学历史。', '读的时候，试着记下你的问题。一本好书有时提供的不是答案，而是更清楚的提问。', 4.50, 1, '2026-11-12 23:37:00.847433+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (12, 'oldman', '老人与海', 'THE OLD MAN AND THE SEA', '欧内斯特·海明威', '文学小说', 128, 1952, '#3d5e63', '#f3ead2', 'lake', '人可以被打败，但不能被毁灭', '硬汉精神', '老渔夫圣地亚哥独自出海，与大鱼缠斗三天。简练的文字里，是关于尊严、失败与坚持的寓言。', '一本可以在一个下午读完、却会用很久去回味的书。', 4.00, 1, '2026-11-12 23:37:00.859034+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (2, 'prince', '小王子', 'LE PETIT PRINCE', '安托万·德·圣埃克苏佩里', '文学小说', 128, 1943, '#d9a252', '#2e3f39', 'planet', '写给每一个曾经是孩子的大人', '重读经典', '一个来自遥远星球的孩子，开启关于相遇、牵挂与告别的旅程。简单的故事里，藏着值得反复追问的生活命题。', '不妨把它当作一封写给长大后的自己的信，每一次重读都能遇见不同的句子。', 5.00, 2, '2026-11-12 23:37:00.842942+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (11, 'gatsby', '了不起的盖茨比', 'THE GREAT GATSBY', 'F.S. 菲茨杰拉德', '文学小说', 256, 1925, '#2f4a52', '#efe6cf', 'moon', '灯火尽头，是回不去的旧梦', '爵士时代', '长岛的夏夜、永不熄灭的绿灯与一场盛大的幻梦。盖茨比用尽一生靠近的那束光，最终照见了时代的空洞。', '读到最后一句，再回头看看开头。菲茨杰拉德把答案放在了最前面。', 4.50, 1, '2026-11-12 23:37:00.857902+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (10, 'jane-eyre', '简·爱', 'JANE EYRE', '夏洛蒂·勃朗特', '文学小说', 448, 1847, '#5a4a4f', '#f2e6d8', 'window', '在爱与尊严之间，保持站立', '独立人格', '一个孤女成长为独立女性的故事。爱情、阶级与信仰在阴冷的英格兰乡间交错，留下一句至今仍有力的自白。', '留意简每一次说“不”的时刻，那是整本书的骨头。', 4.50, 1, '2026-11-12 23:37:00.856962+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (18, 'tao', '道德经', 'TAO TE CHING', '老子', '人文思考', 120, -400, '#5b6b50', '#f1ead2', 'mountain', '以柔克刚，以少胜多', '东方智慧', '八十一章短句，谈道、无为、柔弱与自然。语言极简，留下大量空白，也留下反复解释的可能。', '每次只读一两章，不必急着寻找统一答案。', 5.00, 1, '2026-11-12 23:37:00.86632+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (14, 'stranger', '局外人', 'THE STRANGER', '阿尔贝·加缪', '文学小说', 144, 1942, '#6d6656', '#f4ecd9', 'arch', '在荒诞面前，保持清醒', '荒诞哲学', '默尔索在母亲葬礼上没有哭，后来在一场偶然的冲突中开枪。审判他的，似乎不是行为，而是他不够“合群”的情感。', '先读故事，再读那句关于夏日与幸福的结尾。', 4.50, 1, '2026-11-12 23:37:00.86109+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (15, 'siddhartha', '悉达多', 'SIDDHARTHA', '赫尔曼·黑塞', '人文思考', 192, 1922, '#7b6a45', '#f3ead1', 'mountain', '每个人都要走自己的路', '自我寻找', '婆罗门之子离开家乡，经历苦行、欲望与失去，最终在河边学会倾听。这是一部关于自我教育的小说。', '如果你正站在人生的岔路口，这本书会陪你坐一会儿。', 4.50, 1, '2026-11-12 23:37:00.862285+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (8, 'meditations', '沉思录', 'MEDITATIONS', '马可·奥勒留', '人文思考', 240, 180, '#6f6a60', '#f4eddc', 'arch', '在纷扰中，练习与自己相处', '慢慢读', '古罗马皇帝写给自己的思考笔记，围绕时间、行动、责任与内心秩序展开。篇章简短，却能引出长久的自省。', '无需从头读到尾。选一小段，与今天的一件事放在一起思考。', 4.50, 2, '2026-11-12 23:37:00.852164+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (19, 'analects', '论语', 'THE ANALECTS', '孔子及弟子', '人文思考', 320, -400, '#8a7450', '#f7edd6', 'arch', '学而时习之，不亦说乎', '常读常新', '弟子记录孔子言行的片段，涉及学习、交友、为政与修身。许多句子已成为日常语言的一部分。', '试着把其中一句放进今天的生活里，看看会发生什么。', 0.00, 0, '2026-11-12 23:37:00.868149+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (20, 'zhuangzi', '庄子', 'ZHUANGZI', '庄周', '人文思考', 360, -300, '#6a7f66', '#f0e9d0', 'leaf', '乘物以游心，逍遥于天地', '逍遥之道', '寓言、对话与奇想交织，庄子用蝴蝶、鲲鹏与井蛙，打开另一种看待世界的尺度。', '读的时候放松一点，让它带你绕开熟悉的思路。', 0.00, 0, '2026-11-12 23:37:00.87324+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (21, 'alive', '活着', 'TO LIVE', '余华', '文学小说', 224, 1993, '#9a5e48', '#f8efe0', 'mountain', '为了活着本身，而活着', '中国当代', '福贵一生经历家道中落、战乱与亲人离散，却始终没有停下。平实的叙述里，是命运的重量与人的韧性。', '准备好纸巾，也准备好读完后沉默一会儿。', 0.00, 0, '2026-11-12 23:37:00.875132+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (22, 'xu-sanguan', '许三观卖血记', 'CHRONICLE OF A BLOOD MERCHANT', '余华', '文学小说', 240, 1995, '#8a5a4a', '#f7ecdc', 'window', '一个普通人，用自己的方式撑起家', '平凡人生', '许三观一次次走进医院卖血，为婚姻、孩子和生计解围。荒诞与温情在同一条街上并行。', '留意那些看似轻快的段落，它们往往藏着最重的东西。', 0.00, 0, '2026-11-12 23:37:00.876747+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (24, 'south-city', '城南旧事', 'MY MEMORIES OF PEKING', '林海音', '文学小说', 208, 1960, '#b98b5e', '#fbf1de', 'window', '童年是一条慢慢走远的胡同', '童年记忆', '英子眼中的北京城南，有疯女人、小偷和远走的保姆。孩子的目光不懂评判，却记住了所有离别。', '适合在傍晚读，读完会想起自己小时候住过的那条街。', 0.00, 0, '2026-11-12 23:37:00.879802+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (25, 'hulan', '呼兰河传', 'TALES OF HULAN RIVER', '萧红', '文学小说', 272, 1941, '#8e8770', '#f5eeda', 'mountain', '故乡是记得，也是回不去', '乡土文学', '呼兰河小城的风俗、四季与人情，在萧红笔下既温暖又寒冷。她写故乡，也写被故乡缓慢吞没的人。', '读一读那些关于后花园的段落，那是全书最柔软的地方。', 0.00, 0, '2026-11-12 23:37:00.881029+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (26, 'morning-flowers', '朝花夕拾', 'DAWN BLOSSOMS', '鲁迅', '生活随笔', 208, 1928, '#5e6b58', '#f1e9d6', 'leaf', '旧事重提，温情与锋利并存', '旧事重提', '从百草园到三味书屋，从长妈妈到藤野先生，鲁迅回望少年时代，也回望一个正在远去的中国。', '别把它只当课文。放慢速度，会读到许多课堂上来不及讲的温度。', 0.00, 0, '2026-11-12 23:37:00.882319+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (27, 'yashe', '雅舍小品', 'THE YASHE ESSAYS', '梁实秋', '生活随笔', 256, 1949, '#a08a6a', '#faf1dd', 'window', '把日子过成一篇有趣的文章', '生活趣味', '谈吃、谈住、谈人情，也谈自己。梁实秋的文字从容幽默，在琐碎生活里打捞出自得其乐的趣味。', '适合放在床头，每天读一两篇。', 0.00, 0, '2026-11-12 23:37:00.884541+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (30, 'temple', '我与地坛', 'THE TEMPLE OF EARTH', '史铁生', '生活随笔', 224, 2002, '#8b8172', '#f6eedc', 'arch', '在苦难旁边，重新理解活着', '生命沉思', '轮椅上的史铁生一次次走进地坛，想关于生、死与母亲的事。文字克制，情感却很深。', '读得慢一些，给那些句子留出回声的时间。', 0.00, 0, '2026-11-12 23:37:00.888177+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (31, 'silent-spring', '寂静的春天', 'SILENT SPRING', '蕾切尔·卡逊', '自然行旅', 320, 1962, '#5d7358', '#f1ecd4', 'insect', '当鸟鸣消失，我们才听见警钟', '生态觉醒', '卡逊调查农药对生态的破坏，写下这部改变公共政策的书。它提醒我们，自然从来不是可以随意处置的背景。', '读完之后，留意一下窗外的鸟声。', 0.00, 0, '2026-11-12 23:37:00.889087+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (32, 'sand-county', '沙乡年鉴', 'A SAND COUNTY ALMANAC', '奥尔多·利奥波德', '自然行旅', 288, 1949, '#7f7a58', '#f5eed8', 'leaf', '像山那样思考', '土地伦理', '以一年十二个月的观察为线索，利奥波德记录土地上的生命，也提出人与自然相处的新伦理。', '适合按月份读，跟着书里的季节走一年。', 0.00, 0, '2026-11-12 23:37:00.890133+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (33, 'forest-whale', '森林、冰河与鲸', 'FOREST, ICE AND WHALES', '星野道夫', '自然行旅', 200, 1990, '#4a6670', '#eef1e6', 'lake', '在极北之地，听见时间的回声', '极北之地', '星野道夫长年生活在阿拉斯加，用照片与文字记录森林、冰川、鲸与人的相遇。', '翻开书之前，先把手机调成静音。', 0.00, 0, '2026-11-12 23:37:00.891484+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (35, 'tea-lessons', '日日是好日', 'EVERY DAY IS A GOOD DAY', '森下典子', '生活随笔', 208, 2002, '#9a9a74', '#f8f2dc', 'leaf', '在一碗茶里，练习耐心', '茶道日常', '作者记录二十五年学习茶道的经历，从笨拙到熟练，也从不理解到慢慢懂得。', '留意书中关于季节与水的细节，那是茶道真正的语言。', 0.00, 0, '2026-11-12 23:37:00.894649+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (36, 'frog-therapy', '蛤蟆先生去看心理医生', 'FROG GOES TO THERAPY', '罗伯特·戴博德', '人文思考', 208, 1997, '#6f8a76', '#f2f3e4', 'arch', '理解自己，是改变的开始', '心理成长', '蛤蟆先生情绪低落，在心理咨询师的陪伴下，一点点回看童年与关系。通俗的对话里，是完整的咨询过程。', '如果你或朋友正需要一场谈话，这本书可以作为起点。', 0.00, 0, '2026-11-12 23:37:00.896036+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (37, 'courage', '被讨厌的勇气', 'THE COURAGE TO BE DISLIKED', '岸见一郎 / 古贺史健', '人文思考', 256, 2013, '#566b74', '#eff0e2', 'arch', '自由，就是不再活在别人的期待里', '阿德勒心理学', '以青年与哲人对话的形式，介绍阿德勒心理学：课题分离、共同体感觉与当下的意义。', '读的时候不妨反驳它。真正的理解，往往从争辩开始。', 0.00, 0, '2026-11-12 23:37:00.897074+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (38, 'how-to-read', '如何阅读一本书', 'HOW TO READ A BOOK', '莫提默·艾德勒', '人文思考', 424, 1940, '#7a6b53', '#f7efdb', 'window', '把阅读，变成一门可以练习的手艺', '阅读方法', '从基础阅读到主题阅读，这本书系统讲解如何提问、分析和比较。它不轻松，但很实用。', '可以先读第二篇，立刻用在手边的一本书上。', 0.00, 0, '2026-11-12 23:37:00.898254+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (28, 'plants', '人间草木', 'PLANTS AND HUMANKIND', '汪曾祺', '生活随笔', 240, 1990, '#7d8f62', '#f6efd9', 'leaf', '草木有情，人间有味', '草木有情', '花木、饮食、故乡与旧人，汪曾祺写得松弛而讲究。那些日常小事，在他笔下总有滋有味。', '读完去菜市场走一圈，你会重新看见生活的颜色。', 4.00, 1, '2026-11-12 23:37:00.886177+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (34, 'stationery', '山茶文具店', 'THE KAMAKURA STATIONERY STORE', '小川糸', '生活随笔', 256, 2016, '#c28a72', '#fdf3e4', 'window', '替别人写一封信，也写给自己', '温柔书信', '镰仓的一家文具店，替人代笔写信。每一封信背后，都有一段需要被好好安放的心事。', '读完想给谁写一封信？不妨真的写下来。', 4.50, 1, '2026-11-12 23:37:00.892665+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (23, 'border-town', '边城', 'THE BORDER TOWN', '沈从文', '文学小说', 160, 1934, '#5f7c72', '#f4efdd', 'lake', '茶峒的渡口，有最干净的等待', '湘西风情', '翠翠与祖父守着渡船，也守着一个迟迟没有答案的约定。山水、风俗与少年的心事，被写得清澈而克制。', '慢慢读那些景物描写，它们是故事真正的呼吸。', 4.00, 1, '2026-11-12 23:37:00.878502+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (39, 'maugham-shelter', '阅读是一座随身携带的避难所', 'THE SHELTER OF READING', '威廉·萨默塞特·毛姆', '生活随笔', 272, 1940, '#8c6f5a', '#f9efdd', 'window', '读书，是为了更好地成为自己', '阅读随笔', '毛姆谈读书的乐趣、方法与他喜爱的作家。语气像一个刻薄又真诚的朋友，陪你逛一座书房。', '适合作为下一轮阅读书单的起点。', 0.00, 0, '2026-11-12 23:37:00.899287+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (40, 'bookshop-diary', '书店日记', 'THE DIARY OF A BOOKSELLER', '肖恩·白塞尔', '生活随笔', 352, 2017, '#6b7a65', '#f4edda', 'window', '一家旧书店的四季与牢骚', '书店日常', '苏格兰二手书店老板的日记，记录书、顾客、猫与生意。刻薄、好笑，也藏着对书真正的爱。', '爱逛书店的人会读得很开心。', 0.00, 0, '2026-11-12 23:37:00.90043+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (41, 'charing-cross', '查令十字街84号', '84, CHARING CROSS ROAD', '海莲·汉芙', '生活随笔', 160, 1970, '#b08a5e', '#fbf2e0', 'window', '一段跨越二十年的书信情谊', '书信情缘', '纽约作家与伦敦旧书店之间长达二十年的通信，谈书、谈生活，也谈那些未曾说出口的牵挂。', '读完会想找一家旧书店，认真地写一封信。', 0.00, 0, '2026-11-12 23:37:00.901552+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (42, 'island-bookstore', '岛上书店', 'THE STORIED LIFE OF A.J. FIKRY', '加布瑞埃拉·泽文', '文学小说', 288, 2014, '#4f6b6c', '#f2eddc', 'window', '没有谁是一座孤岛', '书店小说', '小岛书店老板失去妻子与珍本，却在意外到来的孩子身上重新学会生活。温柔的故事，献给所有爱书的人。', '适合在周末一口气读完。', 0.00, 0, '2026-11-12 23:37:00.90299+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (43, 'miracles', '解忧杂货店', 'THE MIRACLE OF NAMIYA', '东野圭吾', '文学小说', 304, 2012, '#6b5a6e', '#f5ecd9', 'moon', '你的烦恼，也许正在被温柔回应', '温柔治愈', '一间可以咨询烦恼的杂货店，把不同年代的人连接在一起。每个选择背后，都有人在认真生活。', '准备一杯热饮，读完会觉得世界柔软了一点。', 0.00, 0, '2026-11-12 23:37:00.903941+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (44, 'no-longer-human', '人间失格', 'NO LONGER HUMAN', '太宰治', '文学小说', 208, 1948, '#5a5f6b', '#efe8d6', 'moon', '在人群里，练习做一个“正常人”', '日本文学', '叶藏从小害怕与人交往，用滑稽的面具换取接纳。剖白式的叙述，写出自我与世界的错位。', '读之前请照顾好情绪，它不是一本轻松的书。', 0.00, 0, '2026-11-12 23:37:00.904746+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (46, 'kafka-shore', '海边的卡夫卡', 'KAFKA ON THE SHORE', '村上春树', '文学小说', 512, 2002, '#4c5a6b', '#f0ead8', 'moon', '在世界的边缘，寻找自己的入口', '奇幻现实', '十五岁的少年离家出走，走向一座私人图书馆；另一条线索里，老人能与猫对话。两条命运线缓慢靠近。', '不必急着解释所有隐喻，跟着走就好。', 0.00, 0, '2026-11-12 23:37:00.906278+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (48, 'solitude', '百年孤独', 'ONE HUNDRED YEARS OF SOLITUDE', '加西亚·马尔克斯', '文学小说', 360, 1967, '#7a6a4e', '#f6eed8', 'moon', '家族的名字会重复，孤独也是', '魔幻现实主义', '布恩迪亚家族七代人的兴衰，与马孔多小镇的诞生和消失交织。奇迹与日常被写得同样真实。', '先记住几个人名，再放心地走进马孔多。', 0.00, 0, '2026-11-12 23:37:00.908453+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (49, 'cholera', '霍乱时期的爱情', 'LOVE IN THE TIME OF CHOLERA', '加西亚·马尔克斯', '文学小说', 400, 1985, '#8a7458', '#faf1dd', 'lake', '等待五十三年，只为再说一次爱', '爱情史诗', '一场跨越半个世纪的等待与重逢。马尔克斯把爱情写成疾病、习惯、执念，也写成一生的事业。', '读到最后，你会重新理解“一生一世”这个词。', 0.00, 0, '2026-11-12 23:37:00.909458+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (50, 'kite-runner', '追风筝的人', 'THE KITE RUNNER', '卡勒德·胡赛尼', '文学小说', 368, 2003, '#7d6a58', '#f7eedb', 'mountain', '为你，千千万万遍', '救赎之路', '阿富汗少年阿米尔与仆人哈桑的友谊，被一次懦弱撕裂。多年后，他踏上回乡赎罪的路。', '准备好面对一些沉重的段落。', 0.00, 0, '2026-11-12 23:37:00.910371+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (51, 'unbearable', '不能承受的生命之轻', 'THE UNBEARABLE LIGHTNESS OF BEING', '米兰·昆德拉', '文学小说', 384, 1984, '#6b6257', '#f4ecd9', 'arch', '轻与重之间，没有标准答案', '存在之思', '托马斯、特蕾莎与萨宾娜在爱情、政治与自由之间挣扎。昆德拉用小说讨论那些无法被简化的人生问题。', '不要寻找单一的主题，它更像一次持续的追问。', 0.00, 0, '2026-11-12 23:37:00.911464+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (52, 'garden-paths', '小径分岔的花园', 'THE GARDEN OF FORKING PATHS', '豪尔赫·路易斯·博尔赫斯', '文学小说', 192, 1941, '#6f7a5a', '#f5efda', 'leaf', '时间是一张不断分岔的网', '迷宫叙事', '短篇故事集，包含侦探、间谍、无限图书馆与时间的迷宫。博尔赫斯用极短的篇幅打开极大的空间。', '一篇一篇读，每篇之间留一点时间。', 0.00, 0, '2026-11-12 23:37:00.912819+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (29, 'sahara', '撒哈拉的故事', 'STORIES OF THE SAHARA', '三毛', '自然行旅', 240, 1976, '#c08a58', '#fbf0dc', 'mountain', '远方不是逃避，是认真地生活', '远方召唤', '三毛与荷西在撒哈拉的日子，有沙漠、邻居、婚礼与琐碎的家务。她把荒凉写成了热烈的人间。', '如果最近觉得生活重复，这本书会替你打开一扇窗。', 4.50, 1, '2026-11-12 23:37:00.887153+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (45, 'norwegian', '挪威的森林', 'NORWEGIAN WOOD', '村上春树', '文学小说', 384, 1987, '#5c6f5a', '#f1ecd7', 'lake', '青春是一场缓慢的告别', '青春记忆', '渡边在两位女孩之间，经历爱、失去与成长。音乐、雨与散步，构成了那个年代的空气。', '戴上耳机，放一首旧歌再读。', 4.00, 1, '2026-11-12 23:37:00.905489+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (47, 'white-night', '白夜行', 'JOURNEY UNDER THE MIDNIGHT SUN', '东野圭吾', '文学小说', 480, 1999, '#434a54', '#eee7d5', 'moon', '有东西代替了太阳', '推理经典', '两个孩子的人生在案件之后分岔，却始终被看不见的线牵在一起。冷静的叙述里，是漫长的黑暗与共生。', '读完后回头想想那些没有写出的部分。', 5.00, 1, '2026-11-12 23:37:00.907254+08');
INSERT INTO public.books (id, slug, title, english, author, category, pages, published_year, color, ink, art, subtitle, tag, description, recommendation, rating_avg, rating_count, created_at) VALUES (1, 'walden', '瓦尔登湖', 'WALDEN', '亨利·戴维·梭罗', '自然行旅', 320, 1854, '#3e5b48', '#eee8d5', 'lake', '在自然中，重新认识生活', '本期主编之选', '走进瓦尔登湖畔的小木屋，观察季节、森林与日常。梭罗的生活实验邀请我们暂缓脚步，思考真正需要的东西。', '适合一个安静的午后。读几页，再抬头看看窗外，你也许会重新发现那些习以为常的风景。', 4.75, 2, '2026-11-12 23:37:00.82507+08');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users (id, email, password_hash, handle, display_name, bio, avatar_color, location, website, is_private, created_at, updated_at) VALUES ('0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'demo@zhijian.app', '$2a$10$D97WSpBlzESGNXJniPmXF.DSXG2G.mQTpc.Yuf/VdKOW9CkXiDRRa', 'demo', '林间', '在城市的缝隙里读书，偶尔写一点关于树和雨的文字。', '#294b3c', '杭州', '', false, '2026-11-12 23:37:01.254733+08', '2026-11-12 23:37:01.254733+08');
INSERT INTO public.users (id, email, password_hash, handle, display_name, bio, avatar_color, location, website, is_private, created_at, updated_at) VALUES ('dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'mia@zhijian.app', '$2a$10$D97WSpBlzESGNXJniPmXF.DSXG2G.mQTpc.Yuf/VdKOW9CkXiDRRa', 'mia', '米娅', '编辑，重读者。相信小说能替人保存那些说不清的情绪。', '#8a5a4a', '上海', '', false, '2026-11-12 23:37:01.269212+08', '2026-11-12 23:37:01.269212+08');
INSERT INTO public.users (id, email, password_hash, handle, display_name, bio, avatar_color, location, website, is_private, created_at, updated_at) VALUES ('b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'chen@zhijian.app', '$2a$10$D97WSpBlzESGNXJniPmXF.DSXG2G.mQTpc.Yuf/VdKOW9CkXiDRRa', 'chen', '陈默', '哲学系毕业，正在练习把读过的句子放进生活。', '#3d5366', '北京', '', false, '2026-11-12 23:37:01.270571+08', '2026-11-12 23:37:01.270571+08');


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('9e66c7b8-4214-4f18-a24e-4a5eed114306', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'finished', 1, '{}', '2026-11-10 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('db00351a-411e-4026-8a81-642ef0ae068d', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'review', 3, '{"title": "理想很亮，也很冷", "rating": 4}', '2026-11-09 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('cfcc938f-56ce-4883-b3d1-587657f25702', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'note', 8, '{"title": "今天只做一件重要的事"}', '2026-11-08 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('d7811a45-5460-462d-8f4e-d865830ebdac', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'list_create', NULL, '{"title": "夜读清单：适合慢慢读的八本书"}', '2026-11-07 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('4c629931-5e43-4f32-b444-7ce0a59c3973', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'finished', 34, '{}', '2026-11-06 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('3a8b7311-b65d-42c2-957e-ec80b2fb167d', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'finished', 15, '{}', '2026-11-05 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('da766e25-c594-4b8b-a3b0-079c33da8f01', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'highlight', 2, '{"quote": "真正重要的东西，用眼睛是看不见的。"}', '2026-11-04 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('87fa77a3-f4a6-4186-ac5a-58b3ed10a0f5', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'club_join', 7, '{"title": "城市里的自然观察"}', '2026-11-03 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('03a53991-03a4-42f8-975b-b6ff285ae6d3', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'review', 18, '{"title": "读得越慢，留白越多", "rating": 5}', '2026-11-02 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('a3b01ff9-32fc-4feb-8ab8-4afae2dc73bd', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'shelf_add', 15, '{"status": "reading"}', '2026-11-01 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('dd7a3416-4539-4a2d-b858-7bfcd90668b2', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'review', 47, '{"title": "她把太阳藏起来了", "rating": 5}', '2026-10-31 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('8d666510-0ef8-4c29-a932-1a6d423712b1', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'finished', 14, '{}', '2026-10-30 12:00:00+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('3d391346-6d86-4f1b-b1d3-d28466e9f32d', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'shelf_add', 10, '{"status": "wishlist"}', '2026-11-18 13:45:43.746123+08');
INSERT INTO public.activities (id, user_id, type, book_id, payload, created_at) VALUES ('a69edbee-f74d-466f-950e-0c1eda6730f0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'shelf_add', 9, '{"status": "wishlist"}', '2026-11-18 14:09:32.851914+08');


--
-- Data for Name: book_tags; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (1, 1, 'mood', '开阔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (2, 1, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (3, 1, 'topic', '自然');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (4, 1, 'topic', '独处');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (5, 1, 'mood', '澄澈');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (6, 2, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (7, 2, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (8, 2, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (9, 2, 'topic', '成长');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (10, 2, 'mood', '温柔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (11, 3, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (12, 3, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (13, 3, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (14, 3, 'topic', '理想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (15, 3, 'mood', '灼热');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (16, 4, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (17, 4, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (18, 4, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (19, 5, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (20, 5, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (21, 5, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (22, 5, 'topic', '女性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (23, 5, 'mood', '清醒');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (24, 6, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (25, 6, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (26, 6, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (27, 6, 'topic', '生活美学');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (28, 7, 'mood', '开阔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (29, 7, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (30, 7, 'topic', '自然');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (31, 7, 'topic', '观察');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (32, 8, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (33, 8, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (34, 8, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (35, 8, 'topic', '自省');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (36, 9, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (37, 9, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (38, 9, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (39, 10, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (40, 10, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (41, 10, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (42, 11, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (43, 11, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (44, 11, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (45, 12, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (46, 12, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (47, 12, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (48, 13, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (49, 13, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (50, 13, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (51, 14, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (52, 14, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (53, 14, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (54, 15, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (55, 15, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (56, 15, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (57, 16, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (58, 16, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (59, 16, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (60, 16, 'pace', '挑战');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (61, 17, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (62, 17, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (63, 17, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (64, 17, 'topic', '政治');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (65, 18, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (66, 18, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (67, 18, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (68, 18, 'topic', '东方哲学');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (69, 19, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (70, 19, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (71, 19, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (72, 19, 'topic', '东方哲学');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (73, 20, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (74, 20, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (75, 20, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (76, 20, 'topic', '东方哲学');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (77, 21, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (78, 21, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (79, 21, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (80, 21, 'topic', '命运');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (81, 21, 'warning', '亲人离世');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (82, 22, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (83, 22, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (84, 22, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (85, 23, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (86, 23, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (87, 23, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (88, 24, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (89, 24, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (90, 24, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (91, 25, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (92, 25, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (93, 25, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (94, 26, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (95, 26, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (96, 26, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (97, 27, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (98, 27, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (99, 27, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (100, 28, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (101, 28, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (102, 28, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (103, 29, 'mood', '开阔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (104, 29, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (105, 29, 'topic', '自然');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (106, 29, 'mood', '热烈');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (107, 30, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (108, 30, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (109, 30, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (110, 30, 'mood', '克制');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (111, 30, 'warning', '疾病与死亡');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (112, 31, 'mood', '开阔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (113, 31, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (114, 31, 'topic', '自然');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (115, 31, 'topic', '环保');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (116, 32, 'mood', '开阔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (117, 32, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (118, 32, 'topic', '自然');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (119, 33, 'mood', '开阔');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (120, 33, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (121, 33, 'topic', '自然');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (122, 34, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (123, 34, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (124, 34, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (125, 35, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (126, 35, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (127, 35, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (128, 36, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (129, 36, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (130, 36, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (131, 36, 'topic', '心理');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (132, 37, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (133, 37, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (134, 37, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (135, 37, 'topic', '心理');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (136, 38, 'mood', '沉思');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (137, 38, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (138, 38, 'topic', '思想');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (139, 38, 'topic', '阅读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (140, 39, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (141, 39, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (142, 39, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (143, 40, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (144, 40, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (145, 40, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (146, 41, 'mood', '安静');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (147, 41, 'pace', '慢读');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (148, 41, 'topic', '日常');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (149, 42, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (150, 42, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (151, 42, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (152, 43, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (153, 43, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (154, 43, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (155, 44, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (156, 44, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (157, 44, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (158, 44, 'warning', '抑郁情绪');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (159, 45, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (160, 45, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (161, 45, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (162, 46, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (163, 46, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (164, 46, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (165, 47, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (166, 47, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (167, 47, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (168, 47, 'warning', '暴力与创伤');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (169, 48, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (170, 48, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (171, 48, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (172, 49, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (173, 49, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (174, 49, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (175, 50, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (176, 50, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (177, 50, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (178, 50, 'warning', '暴力与创伤');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (179, 51, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (180, 51, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (181, 51, 'topic', '人性');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (182, 52, 'mood', '沉浸');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (183, 52, 'pace', '顺畅');
INSERT INTO public.book_tags (id, book_id, kind, name) VALUES (184, 52, 'topic', '人性');


--
-- Data for Name: clubs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.clubs (id, name, slug, description, book_id, is_private, owner_id, created_at) VALUES ('3d551dfc-70f6-4430-aaf6-74c457f3099a', '周末慢读会', 'weekend-slow-reading', '每周挑一本书，不赶进度，只分享读到的句子。周末晚上线上见。', 1, false, '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-09-28 12:00:00+08');
INSERT INTO public.clubs (id, name, slug, description, book_id, is_private, owner_id, created_at) VALUES ('861a552c-d0ad-45b8-9ea9-7be7caac2c37', '城市里的自然观察', 'urban-nature', '在通勤路上、阳台上、公园里，记录身边的植物和昆虫。', 7, false, 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '2026-09-28 12:00:00+08');
INSERT INTO public.clubs (id, name, slug, description, book_id, is_private, owner_id, created_at) VALUES ('3d6547aa-060d-446c-a7ea-9ec9910ebedc', '哲学茶话会', 'philosophy-tea', '一杯茶，一段原文，一次不急于结论的讨论。', 8, false, 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-09-28 12:00:00+08');


--
-- Data for Name: club_members; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('3d551dfc-70f6-4430-aaf6-74c457f3099a', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'owner', '2026-09-29 12:00:00+08');
INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('3d551dfc-70f6-4430-aaf6-74c457f3099a', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'member', '2026-09-29 12:00:00+08');
INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('3d551dfc-70f6-4430-aaf6-74c457f3099a', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'member', '2026-09-29 12:00:00+08');
INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('861a552c-d0ad-45b8-9ea9-7be7caac2c37', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'owner', '2026-09-29 12:00:00+08');
INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('861a552c-d0ad-45b8-9ea9-7be7caac2c37', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'member', '2026-09-29 12:00:00+08');
INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('3d6547aa-060d-446c-a7ea-9ec9910ebedc', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'owner', '2026-09-29 12:00:00+08');
INSERT INTO public.club_members (club_id, user_id, role, joined_at) VALUES ('3d6547aa-060d-446c-a7ea-9ec9910ebedc', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'member', '2026-09-29 12:00:00+08');


--
-- Data for Name: club_posts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('f4f85dd7-f65d-4e96-a45d-7664ab89b260', '3d551dfc-70f6-4430-aaf6-74c457f3099a', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '本周读《瓦尔登湖》的“声”一章。梭罗说我们被太多声音包围，反而听不见自己。大家最近有没有刻意安静下来的时刻？', 116, '2026-11-11 12:00:00+08');
INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('83f0cc68-3f23-4c03-84e2-59117591e772', '3d551dfc-70f6-4430-aaf6-74c457f3099a', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '昨晚关掉所有通知读了四十分钟，久违地听见了窗外的雨。', NULL, '2026-11-12 12:00:00+08');
INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('d3cf17d1-c3c0-4256-bd7b-a33b3a7e2791', '3d551dfc-70f6-4430-aaf6-74c457f3099a', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '我在地铁上读，反而觉得周围的噪音变成了一层背景。也许安静不是没有声音，而是有一个可以回去的地方。', NULL, '2026-11-10 12:00:00+08');
INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('6a3e2dd8-4de0-4f4e-869a-216e45b06a96', '861a552c-d0ad-45b8-9ea9-7be7caac2c37', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '楼下那棵桂花开了。记录一下：今天闻到第一阵桂花香，比去年早了大约一周。', NULL, '2026-11-11 12:00:00+08');
INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('ee07af1c-4e94-487a-8953-e3fa70607696', '861a552c-d0ad-45b8-9ea9-7be7caac2c37', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '小区花坛里看到一只很大的蜗牛，壳是半透明的。拍了下来，明天查查是什么品种。', NULL, '2026-11-09 12:00:00+08');
INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('a8d4d3c4-7cfb-4fe3-b7f4-804691766b21', '3d6547aa-060d-446c-a7ea-9ec9910ebedc', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '《沉思录》里有一句：“你所拥有的只有当下这一刻。”如果认真接受这句话，很多焦虑会失去抓手。', 24, '2026-11-10 12:00:00+08');
INSERT INTO public.club_posts (id, club_id, user_id, content, page, created_at) VALUES ('c67053ae-00b2-4fb0-9d99-8f3690fd5140', '3d6547aa-060d-446c-a7ea-9ec9910ebedc', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '但完全活在当下会不会也很难？人总要为明天做一点准备。', NULL, '2026-11-11 12:00:00+08');


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('d5b069d9-bec9-43ee-999b-37d66c6932a2', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 5, 4.5, '先有一间房，再谈自由', '伍尔夫谈的不只是写作，也是一个人如何为自己争取不被打断的时间。读的时候我在想，属于我的那间“房间”，也许只是每天清晨的半小时。', false, 0, 0, '2026-11-01 12:00:00+08', '2026-11-12 23:37:01.432002+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('0aa8a844-7699-494c-85d2-7a3b6283fd00', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 4.0, '把它放在手边，而不是书架上', '不适合一口气读完。我习惯每天翻两页，遇到心里有事的时候，那些句子会突然变得很具体。', false, 1, 0, '2026-10-28 12:00:00+08', '2026-11-12 23:37:01.433347+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('ace25b91-fc2b-45f8-ac9d-565750a508f7', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 2, 5.0, '给大人看的童话', '小时候以为是冒险故事，现在觉得是一本关于失去的书。玫瑰、狐狸和飞行员，各自代表一种爱的方式。', false, 1, 0, '2026-10-12 12:00:00+08', '2026-11-12 23:37:01.438865+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('01c1e5a0-f261-4567-a522-49feade42327', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 3, 4.0, '理想很亮，也很冷', '毛姆没有把斯特里克兰写成一个值得效仿的人。他自私、冷酷，但他身上那种不管不顾的劲儿，确实让人害怕又羡慕。', false, 1, 1, '2026-10-08 12:00:00+08', '2026-11-12 23:37:01.440037+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('1e33b42f-5724-4211-8e25-f525dba904f7', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 11, 4.5, '绿灯那边，什么也没有', '读到最后，盖茨比的了不起才真正显出来：他知道梦是假的，还是把命押了上去。菲茨杰拉德的句子像夏天的香槟，气泡散了以后只剩苦味。', false, 1, 1, '2026-10-04 12:00:00+08', '2026-11-12 23:37:01.441221+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('cbeb6e07-25ac-42cd-8c14-dc00efd9c9c7', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 10, 4.5, '贫穷、平凡，但灵魂平等', '简·爱最动人的地方，不是她最后得到了爱情，而是她始终没有把自己交出去。那句关于灵魂平等的自白，现在读仍然会起鸡皮疙瘩。', false, 0, 0, '2026-09-30 12:00:00+08', '2026-11-12 23:37:01.442455+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('d39ad655-d432-429c-9858-982b541f1530', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 45, 4.0, '青春是一盘听旧了的磁带', '村上写失去，总是不动声色。直子、绿子、渡边，他们都在用自己的方式确认自己还活着。读完想一个人走很长的路。', false, 0, 0, '2026-09-26 12:00:00+08', '2026-11-12 23:37:01.443836+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('098f1079-d083-47eb-9ea3-e9cb8b66b0a2', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 47, 5.0, '她把太阳藏起来了', '整本书几乎没有正面写那两个人的相处，却让人一直感到他们被同一根线拴着。东野圭吾的克制，比任何解释都可怕。', false, 2, 0, '2026-09-22 12:00:00+08', '2026-11-12 23:37:01.444891+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('9650951d-feb0-473b-99c1-6fe73b716302', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 34, 4.5, '代笔，也是替人安放情绪', '每一封信都有自己的语气和纸张。读的时候会想起手写字的温度。很想给一个很久没联系的人写信。', false, 0, 0, '2026-09-18 12:00:00+08', '2026-11-12 23:37:01.445879+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('f82cf96b-7c9e-4c58-ae11-105674005833', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 1, 4.5, '独处不是逃避，是一种训练', '梭罗的湖边生活并不轻松。他需要砍柴、种豆、应付访客。所谓简朴，是把注意力从多余的东西上收回来。', false, 0, 0, '2026-09-14 12:00:00+08', '2026-11-12 23:37:01.446682+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('4e03c730-4d78-4aa9-a039-75f37fc60f99', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 5.0, '一个皇帝写给自己的提醒', '最打动我的不是那些金句，而是他反复提醒自己同一件事：你控制不了别人，只能控制自己的判断。', false, 0, 0, '2026-09-10 12:00:00+08', '2026-11-12 23:37:01.447732+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('024826c7-7348-4b88-91b5-950c3b79aa37', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 5.0, '读得越慢，留白越多', '“上善若水”被说得太多，反而容易滑过去。真正坐下来读，会发现老子对强硬的东西一直保持警惕。', false, 2, 0, '2026-09-06 12:00:00+08', '2026-11-12 23:37:01.448696+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('3c1398d9-f992-4be4-aef3-ef457b569eac', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 14, 4.5, '他不合群，所以他有罪', '默尔索的悲剧不在于他杀了人，而在于他没有在葬礼上哭。加缪写的是社会如何用情感规范审判一个人。', false, 0, 0, '2026-08-29 12:00:00+08', '2026-11-12 23:37:01.450782+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('ab7358dc-6e0e-4378-8631-d7adfeaf0514', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 15, 4.5, '知识可以传授，智慧不能', '悉达多走了那么多路，最后发现答案在河边。黑塞没有给出方法，只给了一个姿态：倾听。', false, 0, 0, '2026-08-25 12:00:00+08', '2026-11-12 23:37:01.452038+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('88b28fe3-e34a-43dc-835b-04d394dacc07', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 5.0, '把生活缩到最小，再重新放大', '读这本书时，我总想起小时候外婆家的后院。梭罗并没有要求所有人都去湖边住，他只是提醒：有些忙碌是我们自己加上去的。合上书以后，我删掉了两个并不重要的待办。', false, 2, 2, '2026-11-09 12:00:00+08', '2026-11-12 23:37:01.429032+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('98cb39df-6005-41f0-8362-049950e58c84', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 2, 5.0, '每一次重读，都会遇见不同的句子', '小时候读的是星球和狐狸，长大后再读，读到的是责任和告别。真正重要的东西用眼睛是看不见的，这句话被引用太多次，但放在整本书里，仍然有让人安静下来的力量。', false, 2, 1, '2026-11-05 12:00:00+08', '2026-11-12 23:37:01.430665+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('ffe2a4d8-027c-4b18-a449-fbbf9e07328d', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 29, 4.5, '远方也需要认真过日子', '三毛最好看的地方，不是撒哈拉有多远，而是她在那里也要做饭、修屋顶、和邻居打交道。浪漫不是逃离日常，而是把日常过得有劲。', false, 0, 0, '2026-10-24 12:00:00+08', '2026-11-12 23:37:01.434724+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('617c1ea8-9af6-47ce-aba3-57954bef59b7', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 4.0, '读完想去菜市场走一走', '汪曾祺写吃写花，写得很松弛。你会发现生活里那些不起眼的东西，原来都可以被认真对待。', false, 0, 0, '2026-10-20 12:00:00+08', '2026-11-12 23:37:01.43643+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('6e6b875a-dddf-4bd7-a5d2-12a9c859801d', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 12, 4.0, '简洁到只剩骨头，却很有力量', '一个老人、一条鱼、一片海。海明威没有多写一个字的情绪，但读到最后，你会知道他有多累，也知道他没有认输。', false, 0, 0, '2026-10-16 12:00:00+08', '2026-11-12 23:37:01.437821+08');
INSERT INTO public.reviews (id, user_id, book_id, rating, title, content, contains_spoilers, likes_count, comments_count, created_at, updated_at) VALUES ('f9b926cc-b75e-4b69-a1ae-144e3833b84e', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 23, 4.0, '清澈，但不轻', '沈从文把茶峒写得像一幅画，可画里的人并不都快乐。翠翠的等待没有结果，这种留白比悲剧更让人难受。', false, 0, 0, '2026-09-02 12:00:00+08', '2026-11-12 23:37:01.449784+08');


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.comments (id, review_id, user_id, content, created_at) VALUES ('9fb76634-4994-4a43-b7b1-3d3666f01e06', '88b28fe3-e34a-43dc-835b-04d394dacc07', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '“有些忙碌是我们自己加上去的”，这句说到心里了。', '2026-11-11 12:00:00+08');
INSERT INTO public.comments (id, review_id, user_id, content, created_at) VALUES ('729e462d-df89-4065-b366-7b8a6e8a3340', '88b28fe3-e34a-43dc-835b-04d394dacc07', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '梭罗要是活到现在，大概会先把手机扔进湖里。', '2026-11-11 12:00:00+08');
INSERT INTO public.comments (id, review_id, user_id, content, created_at) VALUES ('49059618-1940-4df4-872e-768f81ca9a37', '98cb39df-6005-41f0-8362-049950e58c84', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '我也每年重读一次，每次划线的地方都不一样。', '2026-11-11 12:00:00+08');
INSERT INTO public.comments (id, review_id, user_id, content, created_at) VALUES ('91651d8e-b8df-40ad-8d3b-c6c9c2a2b253', '01c1e5a0-f261-4567-a522-49feade42327', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '绿灯那段我也记了很久。', '2026-11-11 12:00:00+08');
INSERT INTO public.comments (id, review_id, user_id, content, created_at) VALUES ('49186187-fe42-4f82-a28f-f6276d3b391e', '1e33b42f-5724-4211-8e25-f525dba904f7', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '喜欢你说的“没有把自己交出去”。', '2026-11-11 12:00:00+08');


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.follows (follower_id, following_id, created_at) VALUES ('0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '2026-10-13 12:00:00+08');
INSERT INTO public.follows (follower_id, following_id, created_at) VALUES ('0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-10-13 12:00:00+08');
INSERT INTO public.follows (follower_id, following_id, created_at) VALUES ('dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-10-13 12:00:00+08');
INSERT INTO public.follows (follower_id, following_id, created_at) VALUES ('b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-10-13 12:00:00+08');
INSERT INTO public.follows (follower_id, following_id, created_at) VALUES ('dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-10-13 12:00:00+08');
INSERT INTO public.follows (follower_id, following_id, created_at) VALUES ('b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '2026-10-13 12:00:00+08');


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.goals (id, user_id, year, target_books, target_minutes, created_at, updated_at) VALUES ('83c4be07-f317-41dd-9b19-742111773043', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 2026, 30, 9000, '2026-11-12 23:37:01.607934+08', '2026-11-12 23:37:01.607934+08');
INSERT INTO public.goals (id, user_id, year, target_books, target_minutes, created_at, updated_at) VALUES ('92ace719-bcd5-4ef5-b5a2-3caa22b79c57', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 2026, 40, 12000, '2026-11-12 23:37:01.616553+08', '2026-11-12 23:37:01.616553+08');
INSERT INTO public.goals (id, user_id, year, target_books, target_minutes, created_at, updated_at) VALUES ('7b58422e-1ac8-47ab-9dd3-51b008c10dcf', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 2026, 24, 7200, '2026-11-12 23:37:01.618871+08', '2026-11-12 23:37:01.618871+08');


--
-- Data for Name: highlights; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.highlights (id, user_id, book_id, quote, page, note, is_private, created_at) VALUES ('8ef71827-62ba-42f2-b704-21cd1286cee8', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, '我步入丛林，因为我希望活得有意义。', 12, '每次读到这句，都会重新检查自己正在忙的事。', true, '2026-11-10 12:00:00+08');
INSERT INTO public.highlights (id, user_id, book_id, quote, page, note, is_private, created_at) VALUES ('c04224cb-7ae7-48fa-9ffc-141625faaa36', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, '一个人越是能把许多事情放下，他越是富有。', 76, '', true, '2026-10-17 12:00:00+08');
INSERT INTO public.highlights (id, user_id, book_id, quote, page, note, is_private, created_at) VALUES ('40b13b7d-e973-4b97-8fda-d4ddbfc6a821', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 5, '一个人必须有钱，还要有一间自己的房间。', 4, '伍尔夫说的是写作，也不只是写作。', true, '2026-10-05 12:00:00+08');
INSERT INTO public.highlights (id, user_id, book_id, quote, page, note, is_private, created_at) VALUES ('c1e64549-5f9b-45bb-89b1-aa85eb88eda0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, '你有力量控制自己的心灵，而不是外部事件。', 41, '', true, '2026-11-03 12:00:00+08');
INSERT INTO public.highlights (id, user_id, book_id, quote, page, note, is_private, created_at) VALUES ('aada8978-5a3f-4dc6-bb90-b237b20a4cf7', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 2, '真正重要的东西，用眼睛是看不见的。', 72, '', true, '2026-09-09 12:00:00+08');
INSERT INTO public.highlights (id, user_id, book_id, quote, page, note, is_private, created_at) VALUES ('9f7f7dab-954d-4712-b81a-8c5e3ad1eb0d', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, '我胆敢成为别人眼中的疯子，只为追随内心的声音。', 150, '这句话最近一直在脑子里打转。', true, '2026-11-09 12:00:00+08');


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.lists (id, user_id, title, description, is_public, created_at, updated_at) VALUES ('b1b46a8e-ec77-4600-bea5-7764b4b26ef0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '夜读清单：适合慢慢读的八本书', '给那些不想被打扰的夜晚。文字不吵，句子有回音。', true, '2026-11-06 12:00:00+08', '2026-11-06 12:00:00+08');
INSERT INTO public.lists (id, user_id, title, description, is_public, created_at, updated_at) VALUES ('59f357e8-bc10-4793-83e1-87a03ef7c580', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '关于自然的五个下午', '不必远行，从脚下的草地开始观察。', true, '2026-11-06 12:00:00+08', '2026-11-06 12:00:00+08');
INSERT INTO public.lists (id, user_id, title, description, is_public, created_at, updated_at) VALUES ('b3a1bd01-7c72-46f8-a961-3149fd90326e', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '想送给朋友的生日书单', '如果不知道送什么，送一本会被读完的书。', true, '2026-11-06 12:00:00+08', '2026-11-06 12:00:00+08');
INSERT INTO public.lists (id, user_id, title, description, is_public, created_at, updated_at) VALUES ('b141f833-11b0-462c-ade8-4a944b9d69fc', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '女性写作与自由', '她们写下自己的身体、房间与选择。', true, '2026-11-06 12:00:00+08', '2026-11-06 12:00:00+08');
INSERT INTO public.lists (id, user_id, title, description, is_public, created_at, updated_at) VALUES ('311ebc6a-9aa6-4e10-a00b-06be0ce37089', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '东方哲思入门', '从短句开始，不必急着读完。', true, '2026-11-06 12:00:00+08', '2026-11-06 12:00:00+08');


--
-- Data for Name: list_items; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (1, 'b1b46a8e-ec77-4600-bea5-7764b4b26ef0', 1, '', 0, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (2, 'b1b46a8e-ec77-4600-bea5-7764b4b26ef0', 4, '', 1, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (3, 'b1b46a8e-ec77-4600-bea5-7764b4b26ef0', 8, '', 2, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (4, 'b1b46a8e-ec77-4600-bea5-7764b4b26ef0', 6, '', 3, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (5, 'b1b46a8e-ec77-4600-bea5-7764b4b26ef0', 35, '', 4, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (6, 'b1b46a8e-ec77-4600-bea5-7764b4b26ef0', 30, '', 5, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (7, '59f357e8-bc10-4793-83e1-87a03ef7c580', 7, '', 0, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (8, '59f357e8-bc10-4793-83e1-87a03ef7c580', 31, '', 1, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (9, '59f357e8-bc10-4793-83e1-87a03ef7c580', 32, '', 2, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (10, '59f357e8-bc10-4793-83e1-87a03ef7c580', 33, '', 3, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (11, '59f357e8-bc10-4793-83e1-87a03ef7c580', 29, '', 4, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (12, 'b3a1bd01-7c72-46f8-a961-3149fd90326e', 2, '', 0, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (13, 'b3a1bd01-7c72-46f8-a961-3149fd90326e', 42, '', 1, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (14, 'b3a1bd01-7c72-46f8-a961-3149fd90326e', 34, '', 2, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (15, 'b3a1bd01-7c72-46f8-a961-3149fd90326e', 43, '', 3, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (16, 'b141f833-11b0-462c-ade8-4a944b9d69fc', 5, '', 0, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (17, 'b141f833-11b0-462c-ade8-4a944b9d69fc', 10, '', 1, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (18, 'b141f833-11b0-462c-ade8-4a944b9d69fc', 9, '', 2, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (19, '311ebc6a-9aa6-4e10-a00b-06be0ce37089', 18, '', 0, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (20, '311ebc6a-9aa6-4e10-a00b-06be0ce37089', 19, '', 1, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (21, '311ebc6a-9aa6-4e10-a00b-06be0ce37089', 20, '', 2, '2026-11-06 12:00:00+08');
INSERT INTO public.list_items (id, list_id, book_id, note, "position", added_at) VALUES (22, '311ebc6a-9aa6-4e10-a00b-06be0ce37089', 15, '', 3, '2026-11-06 12:00:00+08');


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notes (id, user_id, book_id, title, content, type, page, is_private, created_at, updated_at) VALUES ('845fd70b-e229-4d5c-90d4-679160bba97c', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, '把脚步放慢一点', '今天读到湖边生活的片段，想起很久没有认真观察窗外的树了。也许可以从每天留出十分钟开始，把注意力还给眼前的生活。', 'thought', 36, true, '2026-11-07 12:00:00+08', '2026-11-07 12:00:00+08');
INSERT INTO public.notes (id, user_id, book_id, title, content, type, page, is_private, created_at, updated_at) VALUES ('becb7a49-7d93-4a76-a50c-a325522e6e88', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, '关于“必需品”的清单', '梭罗列出的生活必需品少得惊人：食物、住所、衣物、燃料。我试着列了自己的，发现真正离不开的东西其实没有想象中多。', 'excerpt', 58, true, '2026-10-19 12:00:00+08', '2026-10-19 12:00:00+08');
INSERT INTO public.notes (id, user_id, book_id, title, content, type, page, is_private, created_at, updated_at) VALUES ('f65806ed-fc78-4931-987d-a3fc92619439', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 5, '每天清晨的半小时', '伍尔夫说女性写作需要钱和一间自己的房间。我想，任何想认真做点事的人，都需要一段不被打断的时间。决定把早起后的半小时留给自己。', 'thought', 102, true, '2026-10-03 12:00:00+08', '2026-10-03 12:00:00+08');
INSERT INTO public.notes (id, user_id, book_id, title, content, type, page, is_private, created_at, updated_at) VALUES ('343bac7d-0133-4067-aa16-91b88e5c4b8e', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, '他到底在追什么', '读到斯特里克兰离开妻子那段，第一反应是愤怒。但继续读下去，又不得不承认，有些人就是被某种东西推着走，旁人的评价对他毫无意义。', 'thought', 120, true, '2026-11-10 12:00:00+08', '2026-11-10 12:00:00+08');
INSERT INTO public.notes (id, user_id, book_id, title, content, type, page, is_private, created_at, updated_at) VALUES ('c06152cd-ac95-430e-9716-161fce21a6d8', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, '今天只做一件重要的事', '“不要把时间浪费在想象别人的生活上。”这句话像一盆冷水。今天试着关掉社交软件，把上午留给真正想做的事。', 'thought', 88, true, '2026-10-31 12:00:00+08', '2026-10-31 12:00:00+08');


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notifications (id, user_id, type, actor_id, payload, is_read, created_at) VALUES ('be0bdd66-fc50-4049-adc8-f09938f531e7', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'like', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '{"reviewId": "88b28fe3-e34a-43dc-835b-04d394dacc07"}', false, '2026-11-11 12:00:00+08');
INSERT INTO public.notifications (id, user_id, type, actor_id, payload, is_read, created_at) VALUES ('f57279e6-f55d-46d1-8772-ca92bfc6ac63', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'comment', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '{"excerpt": "梭罗要是活到现在，大概会先把手机扔进湖里。", "reviewId": "88b28fe3-e34a-43dc-835b-04d394dacc07"}', false, '2026-11-11 12:00:00+08');
INSERT INTO public.notifications (id, user_id, type, actor_id, payload, is_read, created_at) VALUES ('3054aad8-ae56-4b88-bf56-7a539ce1e669', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'follow', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '{}', false, '2026-11-10 12:00:00+08');
INSERT INTO public.notifications (id, user_id, type, actor_id, payload, is_read, created_at) VALUES ('7015e34a-2046-468a-a111-cf7a28aa9194', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 'club_post', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '{"excerpt": "我在地铁上读，反而觉得周围的噪音变成了一层背景。", "clubSlug": "weekend-slow-reading"}', false, '2026-11-10 12:00:00+08');


--
-- Data for Name: reading_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('2c876034-2f88-4cf9-9744-d86b8b61cab0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 72, 43, '2026-11-12', '', '2026-11-12 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('c410989e-9d44-4a17-b048-99537938081e', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 6, 46, 28, '2026-11-11', '', '2026-11-11 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('066f1157-97a3-4912-8d85-5de7778aaa36', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 63, 38, '2026-11-10', '', '2026-11-10 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('952fedb9-445c-4bb0-8287-7b50b1bffde1', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 62, 37, '2026-11-09', '', '2026-11-09 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f355c668-ed95-489d-98ae-7e53106cc5b1', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 39, 23, '2026-11-08', '', '2026-11-08 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('edb05342-6c65-46f7-9c5b-f55a19447081', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 36, 22, '2026-11-07', '', '2026-11-07 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('37423413-d86c-42c9-829f-b2470973ae18', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 62, 37, '2026-11-04', '', '2026-11-04 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('9e0bc9d2-e5f1-4b6a-9764-9b853a916135', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 53, 32, '2026-11-01', '', '2026-11-01 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('15edd09d-cc2f-4d98-8cb9-c34d493fd5bd', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 22, 13, '2026-10-27', '', '2026-10-27 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f5934238-a2ab-4c5f-baf3-f1892ccb0413', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 40, 24, '2026-10-26', '', '2026-10-26 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('fdc13b90-df9f-4bc5-9c1d-159b24a02bfc', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 46, 28, '2026-10-23', '', '2026-10-23 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f865dc5f-7ec1-4f35-9bf7-a2f5d71b66e0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 26, 16, '2026-10-19', '', '2026-10-19 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('56c27093-9aa7-4716-9e2c-d0c12991b376', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 46, 28, '2026-10-17', '', '2026-10-17 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('9eeb27a7-63ad-464c-977e-82502e935386', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 21, 13, '2026-10-16', '', '2026-10-16 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('20c2083d-d0f8-4574-803e-b275af12b58b', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 43, 26, '2026-10-12', '', '2026-10-12 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('85ed1f52-f86e-4414-9edb-5100936a34c3', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 21, 13, '2026-10-11', '', '2026-10-11 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('fdcdb3db-13ef-4cf9-a75e-484a517d8d0f', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 21, 13, '2026-10-08', '', '2026-10-08 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('96657f51-2fe4-4f45-beec-17973db909ba', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 57, 34, '2026-10-06', '', '2026-10-06 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('cf03b6d5-cf00-4554-8ab1-c3206dfde7bd', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 86, 52, '2026-10-05', '', '2026-10-05 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('5865c589-8fce-4b1b-b693-bb02ece0c789', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 80, 48, '2026-10-04', '', '2026-10-04 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('c0d275db-cd6d-4dc8-9122-df1c6aff9f3d', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 27, 16, '2026-10-03', '', '2026-10-03 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('43f90200-c186-4ba6-ae85-ccc7300c85dc', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 6, 62, 37, '2026-09-29', '', '2026-09-29 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('a56aaeb1-0df0-4503-a89d-84ce78f22ffc', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 21, 13, '2026-09-28', '', '2026-09-28 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('44234f17-223a-4b61-bac1-583dbd70dc0b', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 42, 25, '2026-09-26', '', '2026-09-26 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('92f81f77-db4f-4a17-bc4f-95c1e49d8e52', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 51, 31, '2026-09-25', '', '2026-09-25 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('94fbb736-716f-420a-aa3b-239d519cbfb1', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 45, 27, '2026-09-22', '', '2026-09-22 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('c083c3e4-f28a-4913-a47a-7c5687df50ce', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 6, 74, 44, '2026-09-21', '', '2026-09-21 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('0536f124-23ff-402f-9dd5-3d789da92249', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 77, 46, '2026-09-17', '', '2026-09-17 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('53202de0-c048-4cfe-9869-10c6a2af6b48', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 55, 33, '2026-09-16', '', '2026-09-16 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('2c03eeeb-f86e-492c-9eea-bf40d3ae53c1', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 51, 31, '2026-09-13', '', '2026-09-13 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('9a594c26-f476-4c35-b239-7fc67a0deb55', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 34, 20, '2026-09-08', '', '2026-09-08 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('96577039-7cc7-4a22-b5b8-0fe1fe38230b', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 87, 52, '2026-09-07', '', '2026-09-07 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('a81bccef-a61f-4fb2-8a57-898eb3cee642', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 62, 37, '2026-09-06', '', '2026-09-06 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('a0bd8262-181d-4845-81fe-6c552efd9925', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 42, 25, '2026-09-01', '', '2026-09-01 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('ce811213-89cd-49f6-86b8-c7cd6b6aed4c', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 71, 43, '2026-08-31', '', '2026-08-31 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('dd771bb6-e940-4c7c-a3d5-dfe9f89931cb', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 49, 29, '2026-08-28', '', '2026-08-28 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('66f11df7-6567-4daf-972d-7c30b9863bd9', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 33, 20, '2026-08-27', '', '2026-08-27 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('86641877-7d3a-4884-b721-4605cae67a6c', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 6, 82, 49, '2026-08-23', '', '2026-08-23 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('12ca6965-7519-4780-b8da-f344a1c526e3', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 57, 34, '2026-08-21', '', '2026-08-21 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('6240e8dd-1f1d-47a5-94a7-f11c2dabbfd0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 30, 18, '2026-08-20', '', '2026-08-20 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('e5fcdd52-d40f-41b4-96e9-947d024828b6', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 68, 41, '2026-08-17', '', '2026-08-17 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('d79b136f-057d-47c9-88df-def29604b533', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 87, 52, '2026-08-12', '', '2026-08-12 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('96833e47-11b9-47f0-8665-bdd61f674cc0', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 65, 39, '2026-08-10', '', '2026-08-10 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('6b885f08-5089-4f8a-87a3-ddb5238a3627', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 42, 25, '2026-08-05', '', '2026-08-05 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('d9414238-1674-47f1-82e0-0fafe801190b', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 40, 24, '2026-07-31', '', '2026-07-31 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f8b4387f-27f2-4c84-9865-23b9c53c6fca', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 88, 53, '2026-07-30', '', '2026-07-30 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f0d94630-a8e7-485a-8969-9b59b917454c', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 82, 49, '2026-07-29', '', '2026-07-29 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('82990eb7-31f9-46ea-ab9e-51dca96bec84', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 45, 27, '2026-07-28', '', '2026-07-28 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('e92ab766-27f6-4d24-b189-dec920eb9ace', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 66, 40, '2026-07-24', '', '2026-07-24 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('9606e847-f172-4d50-a4f9-fdeadc0dd446', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 84, 50, '2026-07-19', '', '2026-07-19 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('658404cf-11db-444d-b42c-9f021e63bf18', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 31, 19, '2026-07-18', '', '2026-07-18 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('beab9509-d764-409d-b334-dd9a147ad61e', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 64, 38, '2026-07-16', '', '2026-07-16 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('62574d2f-f56c-429f-bdaf-a7dbeb445857', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 26, 16, '2026-07-15', '', '2026-07-15 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('ce16b6c7-a783-4e46-9304-3597656f15af', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 47, 28, '2026-07-13', '', '2026-07-13 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('99f36599-c325-45bb-81b2-5160cbc15611', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 67, 40, '2026-07-12', '', '2026-07-12 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f564eaee-0d3c-4f6d-99a4-98810c3f4b95', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 83, 50, '2026-07-08', '', '2026-07-08 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('347328f3-04d3-402c-8de4-b5d709f23988', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 6, 20, 12, '2026-07-03', '', '2026-07-03 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('09f48cb3-0880-46d8-b5b1-9a034b30d7d9', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 74, 44, '2026-07-02', '', '2026-07-02 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('c2999809-0e2c-45f4-86bc-e87842fd98de', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 26, 16, '2026-06-28', '', '2026-06-28 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('d3b689bb-cd31-4ff4-8c22-e346903a305f', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 48, 29, '2026-06-27', '', '2026-06-27 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('d44cf392-9698-49c5-9afd-07d42df4f425', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 84, 50, '2026-06-23', '', '2026-06-23 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('3e429c92-fd54-4edd-9166-a8432ab76514', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 37, 22, '2026-06-19', '', '2026-06-19 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('9e3ac855-ce68-4c2c-980b-af80e49b246f', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 65, 39, '2026-06-18', '', '2026-06-18 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('efad1e80-d8c6-4b85-a083-a1a7add88d53', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 7, 47, 28, '2026-11-12', '', '2026-11-12 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('20c18270-c8a3-4151-9a06-4cd61b6c1541', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 56, 34, '2026-11-11', '', '2026-11-11 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('74e20d8c-e9e9-4527-a244-bdf82c768a2d', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 33, 29, 17, '2026-11-10', '', '2026-11-10 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('deb03dfa-c545-4716-aceb-c8440ad13b86', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 53, 32, '2026-11-09', '', '2026-11-09 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('42fccb93-2fa1-4c10-b5db-f04d8836805d', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 3, 72, 43, '2026-11-08', '', '2026-11-08 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f662c596-e9c0-4e77-92e4-824bc7509e2d', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 63, 38, '2026-11-07', '', '2026-11-07 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('c636dd37-aac2-4afa-8a52-a03111d68718', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 34, 77, 46, '2026-11-06', '', '2026-11-06 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('494721f0-6049-4431-867c-aad886060239', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 60, 36, '2026-11-05', '', '2026-11-05 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('23e1b040-b028-45d1-840e-24f1794335c4', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 7, 46, 28, '2026-11-04', '', '2026-11-04 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('e8b9236f-9eeb-4228-bb63-99354a727b16', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 27, 16, '2026-11-03', '', '2026-11-03 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('79c2186d-09c2-4bc9-813e-fcf18ffdb884', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 33, 38, 23, '2026-11-02', '', '2026-11-02 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('96a3e069-9a4e-43f2-b7b4-30049ef98d89', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 54, 32, '2026-11-01', '', '2026-11-01 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('4fb718f7-b14f-43b6-9e52-e0f0ead916fc', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 3, 78, 47, '2026-10-31', '', '2026-10-31 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('489b6e2c-ef38-4601-9391-a2ef9b0fc44c', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 38, 23, '2026-10-30', '', '2026-10-30 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('e79a273f-34fd-416c-96bd-753ffd0618d1', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 34, 79, 47, '2026-10-29', '', '2026-10-29 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('fd75e16f-2d25-4e3f-b596-4f984b31d709', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 66, 40, '2026-10-28', '', '2026-10-28 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('1ada100d-bf3c-4663-8ff7-f311c05d42b8', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 7, 49, 29, '2026-10-27', '', '2026-10-27 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('0a016daf-0488-438a-8f01-fafb57121117', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 65, 39, '2026-10-26', '', '2026-10-26 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('7afbae0b-cd30-461f-b97e-223ebac94923', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 33, 70, 42, '2026-10-25', '', '2026-10-25 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('ae621ac1-3d71-4771-bdf2-8e2acd78d9a4', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 57, 34, '2026-10-24', '', '2026-10-24 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('b6022f70-7119-46aa-9239-b3eb1ac477d8', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 3, 73, 44, '2026-10-23', '', '2026-10-23 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('28d0c34d-015e-43e7-b2d7-5df643712dd7', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 64, 38, '2026-10-22', '', '2026-10-22 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('5787a0cb-9922-4f20-9464-39266be1410e', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 34, 38, 23, '2026-10-21', '', '2026-10-21 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('1cf6114e-b222-44af-affc-62317049ee1b', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 28, 17, '2026-10-20', '', '2026-10-20 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('84f51d8f-fbcb-4a9f-bc5e-d31bae6dd083', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 7, 59, 35, '2026-10-19', '', '2026-10-19 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('eb3e357d-5dd6-4abb-9c3f-1d54f4674beb', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 33, 20, '2026-10-18', '', '2026-10-18 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('305adc18-da91-4393-8746-f1af27d1452b', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 33, 74, 44, '2026-10-17', '', '2026-10-17 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('e10d2b25-5e63-4c8a-8ea6-a6746aab9838', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 21, 13, '2026-10-16', '', '2026-10-16 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('2859947c-3401-48de-9fe8-7f066ef92c98', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 3, 49, 29, '2026-10-15', '', '2026-10-15 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('2d466d74-aa44-4b01-9e33-83eb81e65093', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 69, 41, '2026-10-14', '', '2026-10-14 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('a91a2a97-bd39-4d0a-9c90-bc60444c8e84', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 34, 70, 42, '2026-10-13', '', '2026-10-13 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('7e8e0429-9f18-4ee0-bd95-e2b4e34883ba', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 29, 17, '2026-10-12', '', '2026-10-12 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('a6e3afa6-808c-4892-a935-8ad430881a76', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 7, 47, 28, '2026-10-11', '', '2026-10-11 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('f09f2cc7-e285-448d-b4fc-501a6805d77e', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 42, 25, '2026-10-10', '', '2026-10-10 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('191d1dca-6b37-49b7-ab9a-11e5f1af393a', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 33, 37, 22, '2026-10-09', '', '2026-10-09 21:00:00+08');
INSERT INTO public.reading_sessions (id, user_id, book_id, minutes, pages, session_date, note, created_at) VALUES ('3a107a4e-24eb-454a-9a4c-24ea12f327cd', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 65, 39, '2026-10-08', '', '2026-10-08 21:00:00+08');


--
-- Data for Name: review_likes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('88b28fe3-e34a-43dc-835b-04d394dacc07', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '2026-11-12 23:37:01.371541+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('88b28fe3-e34a-43dc-835b-04d394dacc07', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-11-12 23:37:01.376435+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('98cb39df-6005-41f0-8362-049950e58c84', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '2026-11-12 23:37:01.378006+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('98cb39df-6005-41f0-8362-049950e58c84', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-11-12 23:37:01.379169+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('ace25b91-fc2b-45f8-ac9d-565750a508f7', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-11-12 23:37:01.37996+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('01c1e5a0-f261-4567-a522-49feade42327', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-11-12 23:37:01.381169+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('1e33b42f-5724-4211-8e25-f525dba904f7', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-11-12 23:37:01.382523+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('0aa8a844-7699-494c-85d2-7a3b6283fd00', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-11-12 23:37:01.383351+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('098f1079-d083-47eb-9ea3-e9cb8b66b0a2', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', '2026-11-12 23:37:01.384347+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('098f1079-d083-47eb-9ea3-e9cb8b66b0a2', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-11-12 23:37:01.38568+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('024826c7-7348-4b88-91b5-950c3b79aa37', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', '2026-11-12 23:37:01.386877+08');
INSERT INTO public.review_likes (review_id, user_id, created_at) VALUES ('024826c7-7348-4b88-91b5-950c3b79aa37', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', '2026-11-12 23:37:01.387852+08');


--
-- Data for Name: user_books; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('8f453116-f5d2-4e88-b03f-17a0e5673650', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 5, 'finished', 100, '2026-07-03 12:00:00+08', '2026-07-17 12:00:00+08', '2026-06-27 12:00:00+08', '2026-06-27 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('a46595e8-d2ae-48b9-b819-5bb29704ada2', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 8, 'finished', 100, '2026-09-17 12:00:00+08', '2026-10-01 12:00:00+08', '2026-09-11 12:00:00+08', '2026-09-11 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('b8e0e0bc-bc4a-4aff-b23f-8ac0379bc80a', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 29, 'finished', 100, '2026-07-25 12:00:00+08', '2026-08-08 12:00:00+08', '2026-07-19 12:00:00+08', '2026-07-19 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('d7a2043e-a706-43e6-8800-8b68d35d6e69', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 28, 'finished', 100, '2026-08-12 12:00:00+08', '2026-08-26 12:00:00+08', '2026-08-06 12:00:00+08', '2026-08-06 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('4c0268df-f327-453c-b233-b4c8dfe8a706', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 12, 'finished', 100, '2026-06-11 12:00:00+08', '2026-06-25 12:00:00+08', '2026-06-05 12:00:00+08', '2026-06-05 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('69f5c634-6703-4489-aa9e-aae58ed1e69f', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 23, 'finished', 100, '2026-04-30 12:00:00+08', '2026-05-14 12:00:00+08', '2026-04-24 12:00:00+08', '2026-04-24 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('7aea8966-4db0-48eb-97a7-b80ff662cdec', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 3, 'reading', 62, '2026-10-17 12:00:00+08', NULL, '2026-10-11 12:00:00+08', '2026-10-11 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('900c068d-9ad6-4dc3-881e-848d00ea515c', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 6, 'reading', 35, '2026-10-04 12:00:00+08', NULL, '2026-09-28 12:00:00+08', '2026-09-28 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('0ed8d500-68cd-4211-9d9e-9e7144156f48', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 15, 'reading', 18, '2026-10-23 12:00:00+08', NULL, '2026-10-17 12:00:00+08', '2026-10-17 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('7520b69b-a766-4d8f-b90d-ce3433bd83ee', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 11, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('3b7a1b9a-6f70-464b-9c83-11f4f672e0c4', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 18, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('06e277b0-8502-45ab-8cf5-883414013d83', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 30, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('01c2c487-b40f-4e42-be3a-8aa04ffd6c2e', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 42, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('7dc93805-7c33-4f63-95d9-841c245fe2bd', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 40, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('15b4dfdc-8fb2-4d12-b010-b4226de33390', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 17, 'dnf', 12, '2026-09-04 12:00:00+08', NULL, '2026-08-29 12:00:00+08', '2026-08-29 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('5d1c7848-0d4c-4a72-a61b-c97f26eff479', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 2, 'finished', 100, '2026-04-02 12:00:00+08', '2026-04-16 12:00:00+08', '2026-03-27 12:00:00+08', '2026-03-27 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('87fd8de3-911e-4b9b-9553-d41b88d0200f', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 3, 'finished', 100, '2026-08-02 12:00:00+08', '2026-08-16 12:00:00+08', '2026-07-27 12:00:00+08', '2026-07-27 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('be30b21f-5cbc-4d21-ac29-f75ab0c8e5e6', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 11, 'finished', 100, '2026-08-26 12:00:00+08', '2026-09-09 12:00:00+08', '2026-08-20 12:00:00+08', '2026-08-20 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('7d329d3c-3565-4cc9-96aa-9963aa09c801', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 10, 'finished', 100, '2026-05-30 12:00:00+08', '2026-06-13 12:00:00+08', '2026-05-24 12:00:00+08', '2026-05-24 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('0130571a-0fdc-4a76-b0db-8ac9d688645a', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 45, 'finished', 100, '2026-09-14 12:00:00+08', '2026-09-28 12:00:00+08', '2026-09-08 12:00:00+08', '2026-09-08 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('680a85be-4cbd-43eb-90a7-ef999b31a87a', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 9, 'finished', 100, '2026-07-03 12:00:00+08', '2026-07-17 12:00:00+08', '2026-06-27 12:00:00+08', '2026-06-27 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('a5e2f84a-0ab1-42f7-90f7-7c2bc22491cf', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 5, 'finished', 100, '2026-09-27 12:00:00+08', '2026-10-11 12:00:00+08', '2026-09-21 12:00:00+08', '2026-09-21 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('6bec2a83-a444-4666-985b-db67b6a7f0c9', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 21, 'finished', 100, '2026-08-14 12:00:00+08', '2026-08-28 12:00:00+08', '2026-08-08 12:00:00+08', '2026-08-08 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('312c34ee-9572-4748-b89b-c60d1a2022de', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 47, 'finished', 100, '2026-07-23 12:00:00+08', '2026-08-06 12:00:00+08', '2026-07-17 12:00:00+08', '2026-07-17 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('71fe4fb2-9c90-428d-8201-ffca2d46d759', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 49, 'finished', 100, '2026-07-01 12:00:00+08', '2026-07-15 12:00:00+08', '2026-06-25 12:00:00+08', '2026-06-25 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('0c329381-6e8f-428b-9e5a-c458940f8ebe', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 34, 'finished', 100, '2026-10-09 12:00:00+08', '2026-10-23 12:00:00+08', '2026-10-03 12:00:00+08', '2026-10-03 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('1117867a-dea6-441a-8985-038ce949060f', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 7, 'reading', 48, '2026-10-19 12:00:00+08', NULL, '2026-10-13 12:00:00+08', '2026-10-13 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('3821f61d-63d1-4852-b144-3b8ac2bf61da', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 33, 'reading', 22, '2026-10-22 12:00:00+08', NULL, '2026-10-16 12:00:00+08', '2026-10-16 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('21eba2ef-a592-4856-a334-5fa78cfb026a', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 51, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('c44e1c50-ce12-456b-9d12-c432fad65026', 'dd3d74f3-bd5f-4477-8466-dbc7565e4d04', 52, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('7aad0e9c-d14f-40f0-b26a-f6e0296d3020', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 1, 'finished', 100, '2026-04-22 12:00:00+08', '2026-05-06 12:00:00+08', '2026-04-16 12:00:00+08', '2026-04-16 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('238b522f-9429-45e6-aff8-6b2cd4479d4d', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 8, 'finished', 100, '2026-09-01 12:00:00+08', '2026-09-15 12:00:00+08', '2026-08-26 12:00:00+08', '2026-08-26 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('6c00115b-3f35-41dd-8575-db9d6b86264a', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 18, 'finished', 100, '2026-06-21 12:00:00+08', '2026-07-05 12:00:00+08', '2026-06-15 12:00:00+08', '2026-06-15 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('87d8150b-9acb-4bc4-b1d3-931bed0701e7', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 23, 'finished', 100, '2026-04-06 12:00:00+08', '2026-04-20 12:00:00+08', '2026-03-31 12:00:00+08', '2026-03-31 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('65109478-9b88-4c75-92a0-57e8314eeb38', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 19, 'finished', 100, '2026-06-01 12:00:00+08', '2026-06-15 12:00:00+08', '2026-05-26 12:00:00+08', '2026-05-26 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('4b820bb9-f5e0-4b35-8950-3fdb1bc708b8', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 20, 'finished', 100, '2026-07-29 12:00:00+08', '2026-08-12 12:00:00+08', '2026-07-23 12:00:00+08', '2026-07-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('b84607de-8c73-4c41-a79f-01637af80386', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 15, 'finished', 100, '2026-09-19 12:00:00+08', '2026-10-03 12:00:00+08', '2026-09-13 12:00:00+08', '2026-09-13 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('372f43ca-dd9c-4d58-8202-62733985f396', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 14, 'finished', 100, '2026-08-24 12:00:00+08', '2026-09-07 12:00:00+08', '2026-08-18 12:00:00+08', '2026-08-18 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('4fe4c29e-a0f9-4015-b1ab-60c10776ce45', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 37, 'reading', 54, '2026-10-14 12:00:00+08', NULL, '2026-10-08 12:00:00+08', '2026-10-08 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('0a450d8b-a196-4693-b2fe-0fe5c7dcb175', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 38, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('a27f7cc3-3cd2-422d-b6c9-8a445ea37784', 'b6a7b9b5-a1bc-44cf-bb14-7406961e6286', 50, 'wishlist', 0, NULL, NULL, '2026-10-23 12:00:00+08', '2026-10-23 12:00:00+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('84aafecf-3461-4e75-8ed8-40a953a6e7ea', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 9, 'wishlist', 0, NULL, NULL, '2026-11-18 14:09:32.841271+08', '2026-11-18 14:09:32.841271+08');
INSERT INTO public.user_books (id, user_id, book_id, status, progress, started_at, finished_at, created_at, updated_at) VALUES ('ec8cda65-3e13-4773-a220-7e593429aa27', '0f6e70f3-42d1-42ff-b6b3-a0bbe74fe50f', 1, 'reading', 50, '2026-08-28 12:00:00+08', NULL, '2026-08-22 12:00:00+08', '2026-11-19 15:42:41.934382+08');


--
-- Name: book_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.book_tags_id_seq', 184, true);


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.books_id_seq', 52, true);


--
-- Name: list_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.list_items_id_seq', 22, true);


--
-- PostgreSQL database dump complete
--

\unrestrict Lwh5lrdUhGodUAAFPlHiNjQXV6lpA1rzUjbJOwUliaa9wOeUzb1VsbIKRByW2WD

