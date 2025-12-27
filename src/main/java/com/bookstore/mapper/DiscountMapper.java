package com.bookstore.mapper;

import com.bookstore.entity.Discount;
import java.util.List;

/**
 * 折扣数据访问层，提供折扣相关的数据库操作
 */
public interface DiscountMapper {
    /**
     * 插入折扣信息
     * @param discount 折扣实体对象
     */
    void insert(Discount discount);
    /**
     * 根据折扣ID查询折扣
     * @param discountId 折扣ID
     * @return 折扣实体对象
     */
    Discount selectById(Integer discountId);
    /**
     * 查询所有折扣
     * @return 折扣列表
     */
    List<Discount> selectAll();
    /**
     * 查询当前有效的折扣
     * @return 折扣列表
     */
    List<Discount> selectCurrent();
    /**
     * 更新折扣信息
     * @param discount 折扣实体对象
     */
    void update(Discount discount);
    /**
     * 根据折扣ID删除折扣
     * @param discountId 折扣ID
     */
    void delete(Integer discountId);
    /**
     * 获取活跃折扣数量
     * @return 活跃折扣数量
     */
    Integer getActiveDiscountCount();
}