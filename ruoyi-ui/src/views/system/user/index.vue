<template>
  <div class="app-container tree-sidebar-manage-wrap">
    <tree-panel
      ref="accountTreeRef"
      :title="currentTreeTitle"
      :tree-data="currentTreeData"
      :search-placeholder="currentTreeSearchPlaceholder"
      :storage-key="currentTreeStorageKey"
      :defaultExpandAll="true"
      @node-click="handleTreeNodeClick"
      @refresh="resetTreeFilter"
    >
      <template #node="{ data }">
        <span class="account-tree-node">
          <i :class="data.children && data.children.length ? 'el-icon-folder-opened' : 'el-icon-document'" class="node-icon" />
          <span class="node-label" :title="data.label">{{ data.label }}</span>
          <span v-if="data.levelLabel" class="node-level-tag">{{ data.levelLabel }}</span>
        </span>
      </template>
    </tree-panel>
    <div class="tree-sidebar-content">
      <div class="content-inner">
        <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
          <el-form-item label="用户名" prop="userName">
            <el-input v-model="queryParams.userName" placeholder="请输入用户名" clearable style="width: 240px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="手机号" prop="phonenumber">
            <el-input v-model="queryParams.phonenumber" placeholder="请输入手机号" clearable style="width: 240px" @keyup.enter.native="handleQuery" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-select v-model="queryParams.status" placeholder="用户状态" clearable style="width: 240px">
              <el-option v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.label" :value="dict.value" />
            </el-select>
          </el-form-item>
          <el-form-item label="创建时间">
            <el-date-picker
              v-model="dateRange"
              style="width: 240px"
              value-format="yyyy-MM-dd"
              type="daterange"
              range-separator="-"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
            <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
          </el-form-item>
        </el-form>

        <div class="policy-strip">
          <div class="policy-strip__text">
            <span class="policy-strip__title">学生自主注册</span>
            <span class="policy-strip__desc">开启后学生可自由注册，关闭后注册页将不可继续提交。</span>
          </div>
          <div class="policy-strip__action">
            <el-switch
              v-model="registerEnabled"
              active-text="开启"
              inactive-text="关闭"
              @change="handleRegisterToggle"
            />
            <el-button type="text" class="policy-strip__refresh" @click="refreshPolicies">刷新</el-button>
          </div>
        </div>

        <el-row :gutter="10" class="mb8">
          <el-col v-if="canManageAccounts" :span="1.5">
            <el-button class="action-btn" type="primary" plain icon="el-icon-plus" size="mini" @click="handleAdd">新增</el-button>
          </el-col>
          <el-col v-if="canManageAccounts" :span="1.5">
            <el-button class="action-btn" type="success" plain icon="el-icon-edit" size="mini" :disabled="single" @click="handleUpdate">修改</el-button>
          </el-col>
          <el-col v-if="canManageStudents" :span="1.5">
            <el-button class="action-btn" type="primary" plain icon="el-icon-check" size="mini" :disabled="!userList || !userList.length" @click="handleToggleAllSelection">全选</el-button>
          </el-col>
          <el-col v-if="canManageStudents" :span="1.5">
            <el-button class="action-btn" type="success" plain icon="el-icon-video-play" size="mini" :disabled="multiple" @click="handleBatchStatusChange('0')">批量启用</el-button>
          </el-col>
          <el-col v-if="canManageStudents" :span="1.5">
            <el-button class="action-btn" type="warning" plain icon="el-icon-video-pause" size="mini" :disabled="multiple" @click="handleBatchStatusChange('1')">批量禁用</el-button>
          </el-col>
          <el-col v-if="canManageStudents" :span="1.5">
            <el-button class="action-btn" type="primary" plain icon="el-icon-key" size="mini" :disabled="multiple" @click="handleBatchResetPwd">批量重置密码</el-button>
          </el-col>
          <el-col v-if="canManageStudents" :span="1.5">
            <el-button class="action-btn" type="danger" plain icon="el-icon-delete" size="mini" :disabled="multiple" @click="handleDelete">批量删除</el-button>
          </el-col>
          <el-col v-if="canManageAccounts" :span="1.5">
            <el-button class="action-btn" type="info" plain icon="el-icon-upload2" size="mini" @click="handleImport">导入</el-button>
          </el-col>
          <el-col v-if="canManageAccounts" :span="1.5">
            <el-button class="action-btn" type="warning" plain icon="el-icon-download" size="mini" @click="handleExport">导出</el-button>
          </el-col>
          <right-toolbar :showSearch.sync="showSearch" @queryTable="getList" :columns="columns" />
        </el-row>

        <el-table ref="userTable" v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
          <el-table-column type="selection" width="50" align="center" :selectable="selectableRow" />
          <el-table-column label="用户编号" align="center" key="userId" prop="userId" v-if="columns.userId.visible" />
          <el-table-column label="用户名" align="center" key="userName" v-if="columns.userName.visible" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <a class="link-type" style="cursor: pointer" @click="handleViewData(scope.row)">{{ scope.row.userName }}</a>
            </template>
          </el-table-column>
          <el-table-column label="用户昵称" align="center" key="nickName" prop="nickName" v-if="columns.nickName.visible" :show-overflow-tooltip="true" />
          <el-table-column label="身份" align="center" key="identityName" prop="identityName" v-if="columns.identityName.visible" :show-overflow-tooltip="true" />
          <el-table-column label="所属学院" align="center" key="academyName" v-if="columns.academyName.visible" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ getAcademyName(scope.row) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="年级" align="center" key="gradeName" v-if="columns.gradeName.visible" width="110">
            <template slot-scope="scope">
              <span>{{ getGradeName(scope.row) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="专业" align="center" key="majorName" v-if="columns.majorName.visible" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ getMajorName(scope.row) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="班级" align="center" key="className" v-if="columns.className.visible" min-width="140" :show-overflow-tooltip="true">
            <template slot-scope="scope">
              <span>{{ getClassName(scope.row) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="手机号" align="center" key="phonenumber" prop="phonenumber" v-if="columns.phonenumber.visible" width="120" />
          <el-table-column label="状态" align="center" key="status" v-if="columns.status.visible">
            <template slot-scope="scope">
              <el-switch
                v-model="scope.row.status"
                active-value="0"
                inactive-value="1"
                :disabled="isAdminAccount(scope.row)"
                @change="handleStatusChange(scope.row)"
              />
            </template>
          </el-table-column>
          <el-table-column label="创建时间" align="center" prop="createTime" v-if="columns.createTime.visible" width="160">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.createTime) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="160" class-name="small-padding fixed-width">
            <template slot-scope="scope">
              <span v-if="isAdminAccount(scope.row)" class="locked-tip">管理员账号不可操作</span>
              <template v-else>
                <el-button size="mini" type="text" icon="el-icon-key" @click="handleResetPwd(scope.row)">重置密码</el-button>
                <el-button size="mini" type="text" icon="el-icon-switch-button" @click="handleStatusChange(scope.row)">
                  {{ scope.row.status === '0' ? '禁用' : '启用' }}
                </el-button>
                <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
              </template>
            </template>
          </el-table-column>
        </el-table>
        <pagination v-show="total > 0" :total="total" :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize" @pagination="getList" />
      </div>
    </div>

    <el-dialog :title="title" :visible.sync="open" width="600px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户昵称" prop="nickName">
              <el-input v-model="form.nickName" placeholder="请输入用户昵称" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="所属学院" prop="deptId">
              <treeselect v-model="form.deptId" :options="enabledDeptOptions" :show-count="true" placeholder="请选择所属学院" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="手机号" prop="phonenumber">
              <el-input v-model="form.phonenumber" placeholder="请输入手机号" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="form.email" placeholder="请输入邮箱" maxlength="50" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item v-if="form.userId === undefined" label="用户名" prop="userName">
              <el-input v-model="form.userName" placeholder="请输入用户名" maxlength="30" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item v-if="form.userId === undefined" label="用户密码" prop="password" :rules="pwdValidator">
              <el-input v-model="form.password" placeholder="请输入用户密码" type="password" maxlength="20" show-password />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="用户性别">
              <el-select v-model="form.sex" placeholder="请选择性别">
                <el-option v-for="dict in dict.type.sys_user_sex" :key="dict.value" :label="dict.label" :value="dict.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-radio-group v-model="form.status">
                <el-radio v-for="dict in dict.type.sys_normal_disable" :key="dict.value" :label="dict.value">{{ dict.label }}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="所属班级">
              <el-select v-model="form.postIds" multiple placeholder="请选择所属班级">
                <el-option v-for="item in postOptions" :key="item.postId" :label="item.postName" :value="item.postId" :disabled="item.status === 1" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="用户身份">
              <el-select v-model="form.roleIds" multiple placeholder="请选择用户身份">
                <el-option v-for="item in roleOptions" :key="item.roleId" :label="item.roleName" :value="item.roleId" :disabled="item.status === 1" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入备注" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确定</el-button>
        <el-button @click="cancel">取消</el-button>
      </div>
    </el-dialog>

    <user-view-drawer ref="userViewRef" />
    <excel-import-dialog
      ref="importUserRef"
      title="用户导入"
      action="/system/user/importData"
      template-action="/system/user/importTemplate"
      template-file-name="user_template"
      update-support-label="是否更新已经存在的用户数据"
      @success="getList"
    />
  </div>
</template>

<script>
import { listUser, getUser, delUser, addUser, updateUser, resetUserPwd, changeUserStatus, deptTreeSelect } from "@/api/system/user"
import Treeselect from "@riophae/vue-treeselect"
import "@riophae/vue-treeselect/dist/vue-treeselect.css"
import TreePanel from "@/components/TreePanel"
import ExcelImportDialog from "@/components/ExcelImportDialog"
import UserViewDrawer from "./view"
import passwordRule from "@/utils/passwordRule"
import { mapGetters } from "vuex"
import { getRegisterEnabled, setRegisterEnabled } from "@/api/account"

export default {
  name: "User",
  mixins: [passwordRule],
  dicts: ["sys_normal_disable", "sys_user_sex"],
  components: { Treeselect, TreePanel, ExcelImportDialog, UserViewDrawer },
  computed: {
    ...mapGetters(["roles"]),
    currentTreeTitle() {
      return "院系分类"
    },
    currentTreeData() {
      return this.deptTreeOptions
    },
    currentTreeSearchPlaceholder() {
      return "请输入学院/专业/班级"
    },
    currentTreeStorageKey() {
      return "account-dept-sidebar-width"
    },
    isAdminRole() {
      return this.roles.includes("admin")
    },
    canManageAccounts() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    },
    canManageStudents() {
      return this.roles.includes("teacher") || this.roles.includes("admin")
    }
  },
  data() {
    return {
      loading: true,
      ids: [],
      selectedRows: [],
      single: true,
      multiple: true,
      showSearch: true,
      total: 0,
      userList: null,
      title: "",
      registerEnabled: false,
      deptOptions: undefined,
      deptTreeOptions: [],
      deptMetaMap: {},
      enabledDeptOptions: undefined,
      open: false,
      initPassword: undefined,
      dateRange: [],
      postOptions: [],
      roleOptions: [],
      form: {},
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        phonenumber: undefined,
        status: undefined,
        deptId: undefined,
        roleId: undefined
      },
      columns: {
        userId: { label: "用户编号", visible: true },
        userName: { label: "用户名", visible: true },
        nickName: { label: "用户昵称", visible: true },
        identityName: { label: "身份", visible: true },
        academyName: { label: "所属学院", visible: true },
        gradeName: { label: "年级", visible: true },
        majorName: { label: "专业", visible: true },
        className: { label: "班级", visible: true },
        phonenumber: { label: "手机号", visible: true },
        status: { label: "状态", visible: true },
        createTime: { label: "创建时间", visible: true }
      },
      rules: {
        userName: [
          { required: true, message: "用户名不能为空", trigger: "blur" },
          { min: 2, max: 20, message: "用户名长度必须介于 2 到 20 之间", trigger: "blur" }
        ],
        nickName: [
          { required: true, message: "用户昵称不能为空", trigger: "blur" }
        ],
        email: [
          { type: "email", message: "请输入正确的邮箱地址", trigger: ["blur", "change"] }
        ],
        phonenumber: [
          { pattern: /^1[3-9]\d{9}$/, message: "请输入正确的手机号码", trigger: "blur" }
        ]
      }
    }
  },
  created() {
    this.applyRouteScope()
    this.getList()
    this.getDeptTree()
    this.refreshPolicies()
    this.getConfigKey("sys.user.initPassword").then(response => {
      this.initPassword = response.msg
    })
  },
  watch: {
    $route() {
      this.applyRouteScope()
      this.handleQuery()
    }
  },
  methods: {
    applyRouteScope() {
      const roleId = Number(this.$route.query.roleId)
      if (Number.isFinite(roleId) && roleId > 0) {
        this.queryParams.roleId = roleId
        return
      }
      const pathRoleMap = {
        "/account/admin": 1,
        "/account/teacher": 3,
        "/account/student": 4
      }
      this.queryParams.roleId = pathRoleMap[this.$route.path] || undefined
    },
    getList() {
      this.loading = true
      listUser(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
        this.userList = response.rows || []
        this.total = response.total
        this.loading = false
      })
    },
    getDeptTree() {
      deptTreeSelect().then(response => {
        this.deptOptions = response.data
        this.deptMetaMap = this.buildDeptMetaMap(response.data || [])
        this.deptTreeOptions = this.buildDeptFilterTree(response.data || [])
        this.enabledDeptOptions = this.filterDisabledDept(JSON.parse(JSON.stringify(response.data || [])))
      })
    },
    buildDeptMetaMap(nodes, path = []) {
      return (nodes || []).reduce((acc, node, index) => {
        const level = path.length
        const label = this.formatSchoolDeptLabel(node.label, level, index)
        const currentPath = [...path, label]
        acc[node.id] = {
          deptId: node.id,
          label,
          path: currentPath,
          academyName: currentPath[0] || "-",
          majorName: currentPath[1] || "-",
          className: currentPath[2] || "-"
        }
        Object.assign(acc, this.buildDeptMetaMap(node.children || [], currentPath))
        return acc
      }, {})
    },
    buildDeptFilterTree(deptList) {
      const tree = [
        {
          id: "dept-0",
          deptId: 0,
          label: "全部院系",
          levelLabel: "全部",
          children: this.decorateDeptNodes(JSON.parse(JSON.stringify(deptList || [])))
        }
      ]
      return tree
    },
    decorateDeptNodes(nodes, level = 0) {
      const levelLabels = ["学院", "专业", "班级"]
      return (nodes || []).map((node, index) => {
        const children = this.decorateDeptNodes(node.children || [], level + 1)
        return {
          ...node,
          id: `dept-${node.id}`,
          deptId: node.id,
          label: this.formatSchoolDeptLabel(node.label, level, index),
          levelLabel: levelLabels[level] || "层级",
          children
        }
      })
    },
    formatSchoolDeptLabel(label, level, index = 0) {
      const rawLabel = label || ""
      if (!rawLabel) {
        return rawLabel
      }
      const schoolFallbackMap = {
        0: ["计算机学院", "经济管理学院", "外国语学院", "马克思主义学院", "艺术学院"],
        1: ["软件工程", "工商管理", "英语", "思想政治教育", "视觉传达设计"],
        2: ["软件工程1班", "工商管理1班", "英语1班", "思政1班", "视觉传达1班"]
      }
      const directMatch = schoolFallbackMap[level] && schoolFallbackMap[level][index]
      if (directMatch) {
        return directMatch
      }
      if (level === 0) {
        return rawLabel
          .replace(/科技|公司/g, "学院")
          .replace(/总学院|分学院/g, "学院")
      }
      if (level === 1) {
        return rawLabel
          .replace(/总公司|分公司/g, "")
          .replace(/部门/g, "专业")
      }
      if (level >= 2) {
        return rawLabel
          .replace(/部门/g, "班")
          .replace(/专业$/, "1班")
      }
      return rawLabel
    },
    isStudentRow(row) {
      return (row.identityName || "").indexOf("学生") !== -1
    },
    isTeacherRow(row) {
      return (row.identityName || "").indexOf("教师") !== -1
    },
    getDeptMeta(row) {
      return this.deptMetaMap[row.deptId] || {}
    },
    getAcademyName(row) {
      if (!this.isTeacherRow(row) && !this.isStudentRow(row)) {
        return "-"
      }
      return this.getDeptMeta(row).academyName || "-"
    },
    getMajorName(row) {
      if (!this.isStudentRow(row)) {
        return "-"
      }
      return this.getDeptMeta(row).majorName || "-"
    },
    getClassName(row) {
      if (!this.isStudentRow(row)) {
        return "-"
      }
      return this.getDeptMeta(row).className || "-"
    },
    getGradeName(row) {
      if (!this.isStudentRow(row)) {
        return "-"
      }
      if (row.grade) {
        return row.grade
      }
      const studentNo = row.studentNo || ""
      const matchedYear = String(studentNo).match(/^(20\d{2})/)
      return matchedYear ? `${matchedYear[1]}级` : "-"
    },
    filterDisabledDept(deptList) {
      return deptList.filter(dept => {
        if (dept.disabled) {
          return false
        }
        if (dept.children && dept.children.length) {
          dept.children = this.filterDisabledDept(dept.children)
        }
        return true
      })
    },
    handleTreeNodeClick(data) {
      this.applyRouteScope()
      this.queryParams.deptId = data.deptId > 0 ? data.deptId : undefined
      this.handleQuery()
    },
    resetTreeFilter() {
      this.queryParams.deptId = undefined
      this.applyRouteScope()
      if (this.$refs.accountTreeRef) {
        this.$refs.accountTreeRef.setCurrentKey(null)
      }
      this.handleQuery()
    },
    refreshPolicies() {
      getRegisterEnabled().then(res => {
        this.registerEnabled = !!res.data
      })
    },
    handleRegisterToggle(val) {
      setRegisterEnabled(val ? "0" : "1").then(() => {
        this.$modal.msgSuccess(val ? "已开启学生自主注册" : "已关闭学生自主注册")
      }).catch(() => {
        this.registerEnabled = !val
      })
    },
    isAdminAccount(row) {
      const identityName = row.identityName || ""
      return row.userId === 1 || identityName.indexOf("管理员") !== -1
    },
    selectableRow(row) {
      return !this.isAdminAccount(row)
    },
    handleToggleAllSelection() {
      if (this.$refs.userTable) {
        this.$refs.userTable.toggleAllSelection()
      }
    },
    getManageRows(rows) {
      return rows.filter(row => !this.isAdminAccount(row))
    },
    handleBatchStatusChange(status) {
      const rows = this.getManageRows(this.selectedRows)
      if (!rows.length) {
        this.$modal.msgWarning("请先选择要操作的学生账号")
        return
      }
      const actionText = status === "0" ? "启用" : "禁用"
      this.$modal.confirm(`确认要批量${actionText}选中的 ${rows.length} 个账号吗？`).then(() => {
        return Promise.all(rows.map(row => changeUserStatus(row.userId, status)))
      }).then(() => {
        this.$modal.msgSuccess(`批量${actionText}成功`)
        this.getList()
      }).catch(() => {})
    },
    handleBatchResetPwd() {
      const rows = this.getManageRows(this.selectedRows)
      if (!rows.length) {
        this.$modal.msgWarning("请先选择要操作的学生账号")
        return
      }
      this.$prompt(`请输入所选 ${rows.length} 个账号的新密码`, "批量重置密码", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputValidator: this.pwdPromptValidator
      }).then(({ value }) => {
        return Promise.all(rows.map(row => resetUserPwd(row.userId, value)))
      }).then(() => {
        this.$modal.msgSuccess("批量重置密码成功")
      }).catch(() => {})
    },
    handleStatusChange(row) {
      if (this.isAdminAccount(row)) {
        this.$modal.msgError("管理员账号不能操作")
        row.status = row.status === "0" ? "1" : "0"
        return
      }
      const text = row.status === "0" ? "启用" : "停用"
      this.$modal.confirm('确认要' + text + '“' + row.userName + '”用户吗？').then(function() {
        return changeUserStatus(row.userId, row.status)
      }).then(() => {
        this.$modal.msgSuccess(text + "成功")
      }).catch(() => {
        row.status = row.status === "0" ? "1" : "0"
      })
    },
    cancel() {
      this.open = false
      this.reset()
    },
    reset() {
      this.form = {
        userId: undefined,
        deptId: undefined,
        userName: undefined,
        nickName: undefined,
        password: undefined,
        phonenumber: undefined,
        email: undefined,
        sex: undefined,
        status: "0",
        remark: undefined,
        postIds: [],
        roleIds: []
      }
      this.resetForm("form")
    },
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    resetQuery() {
      this.dateRange = []
      this.resetForm("queryForm")
      this.queryParams.deptId = undefined
      this.applyRouteScope()
      if (this.$refs.accountTreeRef) {
        this.$refs.accountTreeRef.setCurrentKey(null)
      }
      this.handleQuery()
    },
    handleSelectionChange(selection) {
      this.selectedRows = selection || []
      this.ids = selection.map(item => item.userId)
      this.single = selection.length !== 1
      this.multiple = !selection.length
    },
    handleCommand(command, row) {
      switch (command) {
        case "handleResetPwd":
          this.handleResetPwd(row)
          break
        case "handleAuthRole":
          this.handleAuthRole(row)
          break
        default:
          break
      }
    },
    handleAdd() {
      this.reset()
      getUser().then(response => {
        this.postOptions = response.posts || []
        this.roleOptions = response.roles || []
        this.open = true
        this.title = "新增账号"
        this.form.password = this.initPassword
      })
    },
    handleUpdate(row) {
      this.reset()
      const userId = row.userId || this.ids
      getUser(userId).then(response => {
        this.form = response.data || {}
        this.postOptions = response.posts || []
        this.roleOptions = response.roles || []
        this.$set(this.form, "postIds", response.postIds || [])
        this.$set(this.form, "roleIds", response.roleIds || [])
        this.open = true
        this.title = "修改账号"
        this.form.password = ""
      })
    },
    handleResetPwd(row) {
      this.$prompt(`请输入“${row.userName}”的新密码`, "重置密码", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        closeOnClickModal: false,
        inputValidator: this.pwdPromptValidator
      }).then(({ value }) => {
        resetUserPwd(row.userId, value).then(() => {
          this.$modal.msgSuccess("修改成功，新密码为：" + value)
        })
      }).catch(() => {})
    },
    handleAuthRole(row) {
      this.$router.push("/system/user-auth/role/" + row.userId)
    },
    submitForm() {
      this.$refs.form.validate(valid => {
        if (!valid) {
          return
        }
        if (this.form.userId !== undefined) {
          updateUser(this.form).then(() => {
            this.$modal.msgSuccess("修改成功")
            this.open = false
            this.getList()
          })
        } else {
          addUser(this.form).then(() => {
            this.$modal.msgSuccess("新增成功")
            this.open = false
            this.getList()
          })
        }
      })
    },
    handleDelete(row) {
      const userIds = row.userId ? [row.userId] : this.ids
      const rows = row.userId ? [row] : this.selectedRows
      if (rows.some(item => this.isAdminAccount(item))) {
        this.$modal.msgError("管理员账号不能删除")
        return
      }
      this.$modal.confirm('是否确认删除用户编号为“' + userIds.join("、") + '”的数据项？').then(function() {
        return delUser(userIds)
      }).then(() => {
        this.getList()
        this.$modal.msgSuccess("删除成功")
      }).catch(() => {})
    },
    handleExport() {
      this.download("system/user/export", {
        ...this.queryParams
      }, `user_${new Date().getTime()}.xlsx`)
    },
    handleViewData(row) {
      this.$refs.userViewRef.open(row.userId)
    },
    handleImport() {
      this.$refs.importUserRef.open()
    }
  }
}
</script>

<style scoped lang="scss">
.policy-strip {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin: 8px 0 16px;
  padding: 12px 16px;
  border: 1px solid #e5eaf3;
  border-radius: 10px;
  background: #f8fbff;
}

.policy-strip__text {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.policy-strip__title {
  color: #1f2d3d;
  font-weight: 600;
}

.policy-strip__desc {
  color: #909399;
  font-size: 12px;
}

.policy-strip__action {
  display: flex;
  align-items: center;
  gap: 10px;
}

.policy-strip__refresh {
  padding: 0;
}

.tree-mode-select {
  width: 110px;
  margin-left: 8px;
}

.account-tree-node {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  min-width: 0;
}

.node-level-tag {
  padding: 1px 6px;
  border-radius: 10px;
  background: #eef5ff;
  color: #4a7bd0;
  font-size: 12px;
  line-height: 18px;
}

.action-btn {
  min-width: 96px;
}

.mb8 {
  margin-bottom: 8px;
}
</style>
