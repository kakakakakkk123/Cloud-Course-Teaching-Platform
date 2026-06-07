<template>
  <div class="app-container audit-page">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="82px">
      <el-form-item label="登录账号" prop="userName">
        <el-input v-model="queryParams.userName" placeholder="请输入登录账号" clearable style="width: 220px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="IP 地址" prop="ipaddr">
        <el-input v-model="queryParams.ipaddr" placeholder="请输入 IP 地址" clearable style="width: 180px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="设备号" prop="deviceId">
        <el-input v-model="queryParams.deviceId" placeholder="请输入设备号" clearable style="width: 180px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="MAC" prop="macAddress">
        <el-input v-model="queryParams.macAddress" placeholder="请输入 MAC 地址" clearable style="width: 180px" @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="登录状态" clearable style="width: 150px">
          <el-option v-for="dict in dict.type.sys_common_status" :key="dict.value" :label="dict.label" :value="dict.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="登录时间">
        <el-date-picker
          v-model="dateRange"
          style="width: 250px"
          value-format="yyyy-MM-dd HH:mm:ss"
          type="daterange"
          range-separator="-"
          start-placeholder="开始时间"
          end-placeholder="结束时间"
          :default-time="['00:00:00', '23:59:59']"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete" v-hasPermi="['monitor:logininfor:remove']">删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="el-icon-delete" size="mini" @click="handleClean" v-hasPermi="['monitor:logininfor:remove']">清空</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="primary" plain icon="el-icon-unlock" size="mini" :disabled="single" @click="handleUnlock" v-hasPermi="['monitor:logininfor:unlock']">解锁</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="warning" plain icon="el-icon-download" size="mini" @click="handleExport" v-hasPermi="['monitor:logininfor:export']">导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" />
    </el-row>

    <el-table ref="tables" v-loading="loading" :data="list" @selection-change="handleSelectionChange" :default-sort="defaultSort" @sort-change="handleSortChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="时间" align="center" prop="loginTime" sortable="custom" width="170">
        <template slot-scope="scope">{{ parseTime(scope.row.loginTime) }}</template>
      </el-table-column>
      <el-table-column label="登录账号" align="center" prop="userName" min-width="130" :show-overflow-tooltip="true" sortable="custom" />
      <el-table-column label="IP" align="center" prop="ipaddr" width="130" :show-overflow-tooltip="true" />
      <el-table-column label="地点" align="center" prop="loginLocation" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="设备号" align="center" prop="deviceId" min-width="130" :show-overflow-tooltip="true">
        <template slot-scope="scope">{{ scope.row.deviceId || "-" }}</template>
      </el-table-column>
      <el-table-column label="MAC" align="center" prop="macAddress" min-width="130" :show-overflow-tooltip="true">
        <template slot-scope="scope">{{ scope.row.macAddress || "-" }}</template>
      </el-table-column>
      <el-table-column label="浏览器" align="center" prop="browser" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="系统" align="center" prop="os" min-width="120" :show-overflow-tooltip="true" />
      <el-table-column label="状态" align="center" prop="status" width="90">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.sys_common_status" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="原因" align="center" prop="msg" min-width="160" :show-overflow-tooltip="true" />
      <el-table-column label="操作" align="center" width="80">
        <template slot-scope="scope">
          <el-button type="text" size="mini" @click="handleDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />

    <el-dialog title="登录审计详情" :visible.sync="detailOpen" width="720px" append-to-body>
      <el-descriptions :column="2" border>
        <el-descriptions-item label="登录账号">{{ detail.userName }}</el-descriptions-item>
        <el-descriptions-item label="登录状态">
          <dict-tag :options="dict.type.sys_common_status" :value="detail.status" />
        </el-descriptions-item>
        <el-descriptions-item label="登录时间">{{ parseTime(detail.loginTime) }}</el-descriptions-item>
        <el-descriptions-item label="IP 地址">{{ detail.ipaddr }}</el-descriptions-item>
        <el-descriptions-item label="登录地点">{{ detail.loginLocation }}</el-descriptions-item>
        <el-descriptions-item label="设备号">{{ detail.deviceId || "-" }}</el-descriptions-item>
        <el-descriptions-item label="MAC 地址">{{ detail.macAddress || "-" }}</el-descriptions-item>
        <el-descriptions-item label="浏览器">{{ detail.browser }}</el-descriptions-item>
        <el-descriptions-item label="操作系统">{{ detail.os }}</el-descriptions-item>
        <el-descriptions-item label="失败/成功原因" :span="2">{{ detail.msg }}</el-descriptions-item>
        <el-descriptions-item label="User-Agent" :span="2">{{ detail.userAgent || "-" }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </div>
</template>

<script>
import { list, delLogininfor, cleanLogininfor, unlockLogininfor } from "@/api/monitor/logininfor"

export default {
  name: "Logininfor",
  dicts: ["sys_common_status"],
  data() {
    return {
      loading: true,
      ids: [],
      single: true,
      multiple: true,
      selectName: "",
      showSearch: true,
      total: 0,
      list: [],
      dateRange: [],
      detailOpen: false,
      detail: {},
      defaultSort: { prop: "loginTime", order: "descending" },
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        ipaddr: undefined,
        userName: undefined,
        deviceId: undefined,
        macAddress: undefined,
        status: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    getList() {
      this.loading = true
      list(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.list = response.rows || []
        this.total = response.total || 0
        this.loading = false
      })
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.queryParams.pageNum = 1
      this.$refs.tables.sort(this.defaultSort.prop, this.defaultSort.order)
    },
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.infoId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
      this.selectName = selection.map(item => item.userName)
    },
    handleSortChange(column) {
      this.queryParams.orderByColumn = column.prop
      this.queryParams.isAsc = column.order
      this.getList()
    },
    handleDetail(row) {
      this.detail = row
      this.detailOpen = true
    },
    handleDelete(row) {
      const infoIds = row.infoId || this.ids
      this.$modal.confirm(`是否确认删除访问编号为“${infoIds}”的数据项？`).then(() => {
        return delLogininfor(infoIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleClean() {
      this.$modal.confirm("是否确认清理超过保留期的登录审计数据？").then(() => {
        return cleanLogininfor()
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("清空成功")
      }).catch(() => {})
    },
    handleUnlock() {
      const username = this.selectName
      this.$modal.confirm(`是否确认解锁用户“${username}”？`).then(() => {
        return unlockLogininfor(username)
      }).then(() => {
        this.$modal.msgSuccess(`用户 ${username} 解锁成功`)
      }).catch(() => {})
    },
    handleExport() {
      this.download("monitor/logininfor/export", {
        ...this.queryParams
      }, `logininfor_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
