<template>
  <v-container>
    <v-row class="layout" justify="center">
      <v-col cols="8">
        <h2 class="mb-5">ユーザー登録</h2>
        <v-form>
          <v-text-field
            v-model="name"
            dense
            type="name"
            label="アカウント名"
            outlined
            placeholder="お名前"
            class="mb-5"
          />
          <v-text-field
            v-model="email"
            dense
            type="email"
            label="メールアドレス"
            outlined
            placeholder="test@example.com"
            class="mb-5"
          />
          <v-text-field
            v-model="password"
            dense
            type="password"
            label="パスワード(半角英数字)"
            outlined
            placeholder="********"
            class="mb-10"
          />
          <v-btn
            color="#42a0e3"
            block
            rounded
            depressed
            nuxt
            :loading="loading"
            class="white--text font-weight-bold"
            >登録</v-btn
          >
        </v-form>
      </v-col>
    </v-row>
  </v-container>
</template>

<style module lang="scss">
.layout {
  background: #fff;
  margin: 20px auto 0;
  width: 500px;
  padding: 20px 0;
  display: flex;
  justify-content: center;
}
</style>
