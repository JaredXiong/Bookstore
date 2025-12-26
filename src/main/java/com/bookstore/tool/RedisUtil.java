package com.bookstore.tool;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class RedisUtil {
    private static final JedisPool jedisPool;

    static {
        // 加载配置文件
        InputStream is = RedisUtil.class.getClassLoader().getResourceAsStream("redis.properties");
        Properties properties = new Properties();
        try {
            properties.load(is);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("加载 Redis 配置文件失败");
        }

        // 配置连接池
        JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
        jedisPoolConfig.setMaxTotal(Integer.parseInt(properties.getProperty("redis.maxTotal")));
        jedisPoolConfig.setMaxIdle(Integer.parseInt(properties.getProperty("redis.maxIdle")));
        jedisPoolConfig.setMinIdle(Integer.parseInt(properties.getProperty("redis.minIdle")));
        jedisPoolConfig.setMaxWaitMillis(Long.parseLong(properties.getProperty("redis.maxWaitMillis")));

        // 创建连接池
        String host = properties.getProperty("redis.host");
        int port = Integer.parseInt(properties.getProperty("redis.port"));
        String password = properties.getProperty("redis.password");
        int database = Integer.parseInt(properties.getProperty("redis.database"));

        // 根据密码是否存在选择不同的构造函数
        if (password != null && !password.isEmpty()) {
            jedisPool = new JedisPool(jedisPoolConfig, host, port, 2000, password, database);
        } else {
            // 当密码为空时，传递null作为密码参数，而不是使用数据库索引
            jedisPool = new JedisPool(jedisPoolConfig, host, port, 2000, null, database);
        }
    }

    /**
     * 获取Jedis实例
     * @return Jedis实例
     */
    public static Jedis getJedis() {
        return jedisPool.getResource();
    }

    /**
     * 关闭Jedis连接
     * @param jedis Jedis实例
     */
    public static void closeJedis(Jedis jedis) {
        if (jedis != null) {
            jedis.close();
        }
    }

    /**
     * 设置键值对，带过期时间
     * @param key 键
     * @param value 值
     * @param expireTime 过期时间（秒）
     * @return 操作结果
     */
    public static String setex(String key, String value, int expireTime) {
        Jedis jedis = null;
        try {
            jedis = getJedis();
            return jedis.setex(key, expireTime, value);
        } finally {
            closeJedis(jedis);
        }
    }

    /**
     * 获取键对应的值
     * @param key 键
     * @return 值
     */
    public static String get(String key) {
        Jedis jedis = null;
        try {
            jedis = getJedis();
            return jedis.get(key);
        } finally {
            closeJedis(jedis);
        }
    }

    /**
     * 删除键
     * @param key 键
     * @return 操作结果
     */
    public static Long del(String key) {
        Jedis jedis = null;
        try {
            jedis = getJedis();
            return jedis.del(key);
        } finally {
            closeJedis(jedis);
        }
    }

    /**
     * 判断键是否存在
     * @param key 键
     * @return 是否存在
     */
    public static Boolean exists(String key) {
        Jedis jedis = null;
        try {
            jedis = getJedis();
            return jedis.exists(key);
        } finally {
            closeJedis(jedis);
        }
    }
}