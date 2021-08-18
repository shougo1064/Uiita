import Vue from 'vue'
import Router from 'vue-router'
import { normalizeURL } from '@nuxt/ufo'
import { interopDefault } from './utils'
import scrollBehavior from './router.scrollBehavior.js'

const _317f9fc6 = () => interopDefault(import('../pages/sign_in.vue' /* webpackChunkName: "pages/sign_in" */))
const _0852f2da = () => interopDefault(import('../pages/sign_up.vue' /* webpackChunkName: "pages/sign_up" */))
const _c734246e = () => interopDefault(import('../pages/writing_article.vue' /* webpackChunkName: "pages/writing_article" */))
const _15a6d725 = () => interopDefault(import('../pages/articles/_id/index.vue' /* webpackChunkName: "pages/articles/_id/index" */))
const _c90958f2 = () => interopDefault(import('../pages/articles/_id/edit.vue' /* webpackChunkName: "pages/articles/_id/edit" */))
const _63f5fc08 = () => interopDefault(import('../pages/index.vue' /* webpackChunkName: "pages/index" */))

// TODO: remove in Nuxt 3
const emptyFn = () => {}
const originalPush = Router.prototype.push
Router.prototype.push = function push (location, onComplete = emptyFn, onAbort) {
  return originalPush.call(this, location, onComplete, onAbort)
}

Vue.use(Router)

export const routerOptions = {
  mode: 'history',
  base: '/',
  linkActiveClass: 'nuxt-link-active',
  linkExactActiveClass: 'nuxt-link-exact-active',
  scrollBehavior,

  routes: [{
    path: "/sign_in",
    component: _317f9fc6,
    name: "sign_in"
  }, {
    path: "/sign_up",
    component: _0852f2da,
    name: "sign_up"
  }, {
    path: "/writing_article",
    component: _c734246e,
    name: "writing_article"
  }, {
    path: "/articles/:id",
    component: _15a6d725,
    name: "articles-id"
  }, {
    path: "/articles/:id?/edit",
    component: _c90958f2,
    name: "articles-id-edit"
  }, {
    path: "/",
    component: _63f5fc08,
    name: "index"
  }],

  fallback: false
}

function decodeObj(obj) {
  for (const key in obj) {
    if (typeof obj[key] === 'string') {
      obj[key] = decodeURIComponent(obj[key])
    }
  }
}

export function createRouter () {
  const router = new Router(routerOptions)

  const resolve = router.resolve.bind(router)
  router.resolve = (to, current, append) => {
    if (typeof to === 'string') {
      to = normalizeURL(to)
    }
    const r = resolve(to, current, append)
    if (r && r.resolved && r.resolved.query) {
      decodeObj(r.resolved.query)
    }
    return r
  }

  return router
}
