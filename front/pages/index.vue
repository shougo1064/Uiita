<template>
  <div></div>
</template>

<script>
export default {
  async created() {
    try {
      await this.$store.dispatch('article/fetchArticles')
    } catch (err) {
      alert(err.response.statusText)
    }
  },
}
</script>
