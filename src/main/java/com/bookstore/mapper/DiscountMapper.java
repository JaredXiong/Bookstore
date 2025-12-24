package com.bookstore.mapper;

import com.bookstore.entity.Discount;
import java.util.List;

public interface DiscountMapper {
    void insert(Discount discount);
    Discount selectById(Integer discountId);
    List<Discount> selectAll();
    List<Discount> selectCurrent();
    void update(Discount discount);
    void delete(Integer discountId);
}
