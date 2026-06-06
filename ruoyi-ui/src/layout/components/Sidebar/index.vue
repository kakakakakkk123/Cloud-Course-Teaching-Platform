<template>
    <div :class="['sidebar-theme-wrapper', {'has-logo':showLogo}, settings.sideTheme]" :style="{ backgroundColor: settings.sideTheme === 'theme-dark' ? variables.menuBackground : variables.menuLightBackground }">
        <logo v-if="showLogo" :collapse="isCollapse" />
        <el-scrollbar :class="settings.sideTheme" wrap-class="scrollbar-wrapper">
            <el-menu
                :default-active="activeMenu"
                :collapse="isCollapse"
                :background-color="settings.sideTheme === 'theme-dark' ? variables.menuBackground : variables.menuLightBackground"
                :text-color="settings.sideTheme === 'theme-dark' ? variables.menuColor : variables.menuLightColor"
                :unique-opened="true"
                :active-text-color="settings.theme"
                :collapse-transition="false"
                mode="vertical"
            >
                <sidebar-item
                    v-for="(route, index) in sidebarRouters"
                    :key="route.path  + index"
                    :item="route"
                    :base-path="route.path"
                />
            </el-menu>
        </el-scrollbar>
        <button
            :class="['sidebar-home-link', { 'is-collapse': isCollapse }]"
            type="button"
            title="返回主页"
            @click="goHome"
        >
            <i class="el-icon-house"></i>
            <span v-show="!isCollapse">返回主页</span>
        </button>
    </div>
</template>

<script>
import { mapGetters, mapState } from "vuex"
import Logo from "./Logo"
import SidebarItem from "./SidebarItem"
import variables from "@/assets/styles/variables.scss"

export default {
    components: { SidebarItem, Logo },
    computed: {
        ...mapState(["settings"]),
        ...mapGetters(["sidebarRouters", "sidebar"]),
        activeMenu() {
            const route = this.$route
            const { meta, path } = route
            // if set path, the sidebar will highlight the path you set
            if (meta.activeMenu) {
                return meta.activeMenu
            }
            return path
        },
        showLogo() {
            return this.$store.state.settings.sidebarLogo
        },
        variables() {
            return variables
        },
        isCollapse() {
            return !this.sidebar.opened
        }
    },
    methods: {
        goHome() {
            this.$router.push("/")
        }
    }
}
</script>

<style lang="scss" scoped>
.sidebar-theme-wrapper {
    height: 100%;
    display: flex;
    flex-direction: column;

    ::v-deep .el-scrollbar {
        flex: 1;
        height: auto !important;
    }
}

.sidebar-home-link {
    width: calc(100% - 24px);
    height: 40px;
    margin: 8px 12px 12px;
    border: 0;
    border-radius: 6px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 14px;
    line-height: 1;
    cursor: pointer;
    transition: background-color .2s ease, color .2s ease;
}

.sidebar-home-link i {
    font-size: 16px;
}

.sidebar-home-link.is-collapse {
    width: 40px;
    margin-left: 8px;
    margin-right: 8px;
}

.theme-dark .sidebar-home-link {
    color: #bfcbd9;
    background: rgba(255, 255, 255, .06);
}

.theme-dark .sidebar-home-link:hover {
    color: #ffffff;
    background: rgba(64, 158, 255, .22);
}

.theme-light .sidebar-home-link {
    color: #303133;
    background: #f4f6f8;
}

.theme-light .sidebar-home-link:hover {
    color: #409eff;
    background: #ecf5ff;
}
</style>
