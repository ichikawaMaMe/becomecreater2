// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application";

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", () => {
  const commentForm = document.getElementById("comment_form");

  if (commentForm) {
    commentForm.addEventListener("ajax:success", (event) => {
      const [data, status, xhr] = event.detail;

      // コメントのリストを再レンダリング
      const commentIndex = document.getElementById("comment_index");
      commentIndex.innerHTML += `
        <div>
          <strong>${data.user.name}</strong>: ${data.comment}
        </div>
      `;

      // フォームをリセット
      commentForm.reset();
    });

    commentForm.addEventListener("ajax:error", (event) => {
      const [data, status, xhr] = event.detail;

      // エラーを表示
      console.error("エラーが発生しました:", data);
      alert("コメントの投稿に失敗しました。");
    });
  }
});