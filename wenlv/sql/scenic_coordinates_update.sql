-- ============================================================
-- 宁夏景区经纬度坐标补充脚本
-- 执行此脚本可为 scenic_spot 表补充真实的经纬度坐标
-- 这样地图页面可以精确定位，无需依赖POI搜索
-- ============================================================

-- 沙坡头景区 (中卫市沙坡头区迎水桥镇)
UPDATE scenic_spot SET latitude=37.4655, longitude=104.9988 WHERE name='沙坡头景区';

-- 沙湖景区 (石嘴山市平罗县)
UPDATE scenic_spot SET latitude=38.8268, longitude=106.3655 WHERE name='沙湖景区';

-- 西夏王陵 (银川市西夏区贺兰山东麓)
UPDATE scenic_spot SET latitude=38.4350, longitude=106.0025 WHERE name='西夏王陵';

-- 镇北堡西部影城 (银川市西夏区镇北堡镇)
UPDATE scenic_spot SET latitude=38.6150, longitude=106.0715 WHERE name='镇北堡西部影城';

-- 贺兰山岩画 (银川市贺兰县贺兰山)
UPDATE scenic_spot SET latitude=38.7195, longitude=106.0188 WHERE name='贺兰山岩画';

-- 水洞沟遗址 (银川市灵武市临河镇)
UPDATE scenic_spot SET latitude=38.3180, longitude=106.5215 WHERE name='水洞沟遗址';

-- 青铜峡108塔 (吴忠市青铜峡市黄河西岸)
UPDATE scenic_spot SET latitude=37.8815, longitude=105.9820 WHERE name='青铜峡108塔';

-- 须弥山石窟 (固原市原州区须弥山)
UPDATE scenic_spot SET latitude=36.2750, longitude=106.1985 WHERE name='须弥山石窟';
