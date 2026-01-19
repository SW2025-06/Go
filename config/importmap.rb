# config/importmap.rb
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# controllers フォルダを自動で importmap に登録
pin_all_from "app/javascript/controllers", under: "controllers"
