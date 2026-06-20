package com.tennis.utils;

import java.util.List;

/**
 * 分页工具类
 */
public class PageBean<T> {
    private int pageNum;       // 当前页码
    private int pageSize;      // 每页条数
    private int totalCount;    // 总记录数
    private int totalPages;    // 总页数
    private int startIndex;    // 起始索引
    private List<T> list;      // 当前页数据

    public PageBean(int pageNum, int pageSize, int totalCount) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
        this.startIndex = (pageNum - 1) * pageSize;
    }

    public int getPageNum() { return pageNum; }
    public void setPageNum(int pageNum) { this.pageNum = pageNum; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
    public int getStartIndex() { return startIndex; }
    public void setStartIndex(int startIndex) { this.startIndex = startIndex; }
    public List<T> getList() { return list; }
    public void setList(List<T> list) { this.list = list; }
}
