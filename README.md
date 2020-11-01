### Mackenzie의 12개 웹 앱 만들기 프로젝트
### Ruby on Rails in MacOS 10.12

## 목차

Chapter 01. [Reddit Clone](#reddit-clone)    
Chapter 02. [Blog](#blog)    
Chapter 03. [Recipe Box](#recipe-box)    
Chapter 04. [Pinterest Clone](#pinterest-clone)

---

## Reddit Clone
- 2020-10-20
>레일즈 프로젝트를 생성합니다.
``` terminal
$ sudo rails new redditclone
```
>프로젝트 폴더로 이동합니다.    
>레일즈 서버를 시작해줍니다.    
``` terminal
$ cd redditclone
$ sudo rails server
```
>테스트를 완료하고 'Ctrl + C'를 이용해 레일즈 서버를 종료합니다.
``` terminal
$ ^C
```
- 2020-10-21
>link 스캐폴드를 생성합니다.
``` terminal
$ sudo rails generate scaffold link title:string url:string
```
>스캐폴드로 만든 데이터베이스를 마이그레이션합니다.
``` terminal
$ sudo rake db:migrate
```
>레일즈 서버를 시작해줍니다.
``` terminal
$ sudo rails server
```
>해당 주소로 접속해줍니다.
```
http://localhost:3000/links
```
>링크를 추가하고 작동하는지 확인합니다.    
>잘 동작하는지 확인하고 서버를 종료합니다.
``` terminal
$ ^C
```
>Gemfile에 다음 항목을 추가하고 저장합니다.
``` gemfile
gem 'devise'
```
>터미널에서 다음 명령어를 실행하여 devise를 설치합니다.
``` terminal
$ sudo bundle install
```
>devise 설치를 완료해줍니다.
``` terminal
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일을 수정합니다.
``` rb
config.action_mailer.default_url_option = {
  host: 'localhost',
  port: 3000
}
```
>route.rb파일에 경로를 설정합니다. root를 링크 인덱스 페이지로 만듭니다.
``` rb
root('links#index')
```
>route.rb가 적용이 잘 되었는지 확인합니다.
```
$ sudo rails server
```
>app/views/layouts/application.html.erb에 다음을 추가합니다.
``` erb
<% flash.each do |name, msg| %>
  <%= content_tag(:div, msg, class: "alert alert-#{name}") %>
<% end %>
```
>view와 user를 생성합니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise:User
```
>데이터베이스를 마이그레이션합니다.
``` terminal
$ sudo rake db:migrate
```
>웹 앱이 잘 작동하는지 확인하기 위해 서버를 실행하고 다음으로 이동하세요.
```
$ sudo rails server
http://localhost:3000/users/sign_up
```
>잘 작동한다면 회원가입을 합니다.
```
Email: test@email.com
Password: passwd
```
>서버를 죽이고 사용자가 생성되었는지 확인합니다. 결과는 1입니다.
``` terminal
$ sudo rails c
$ User.count
  => 1
```
>이메일이 잘 표시되는지 확인합니다. 'Ctrl + d'를 이용해 레일즈 콘솔을 종료합니다.
``` terminal
$ @user = User.first
  => email: "test@email.com"
$ ^D
```
>app/views/layouts/application.html.erb 파일에서 로그인 여부에 따라 다른 링크를 제공하는 조건문을 추가합니다.
``` erb
<% if user_signed_in? %>
  <ul>
    <li><%= link_to 'Submit link', new_link_path %></li>
    <li><%= link_to 'Account', edit_user_registration_path %></li>
    <li><%= link_to 'Sign out', destroy_user_session_path, :method => :delete %></li>
  </ul>
<% else %>
  <ul>
    <li><%= link_to 'Sign up', new_user_registration_path %></li>
    <li><%= link_to 'Sign in', new_user_session_path %></li>
  </ul>
<% end%>
```
>잘 동작하는지 확인하기 위해 서버를 실행합니다. 로그인과 로그아웃 모두 동작하는지 확인합니다.
``` terminal
$ sudo rails server
```
>등록되지 않은 사용자가 링크를 추가할 수 없도록 app/models/user.rb에 다음 코드를 추가합니다.
``` rb
has_many :link
```
>app/models/link.rb에 연결을 추가합니다.
``` rb
belongs_to :user
```
>검사를 위해 레일즈 콘솔로 이동합니다.
``` terminal
$ sudo rails c
```
>첫 번째 링크가 무엇인지 출력합니다.
``` terminal
$ @link = Link.first
  => title: "pxzhu's Github Reddit Clone", url: "https://github.com/pxzhu/12_Challenge/tree/main/re..."
```
>다음과 같이 콘솔에 작성하면 nil을 반환한다.    
>User와 link 간의 연결이 없었으면 쿼리에 대한 오류 메시지가 표시되었을것이다.    
>nil은 오류가 아니다.    
>사용자 column을 데이터베이스에 추가하지 않았기 때문이다.
``` terminal
$ @link.user
  => nil
```
>link 데이터베이스에 User를 추가하기 위해 마이그레이션을 합니다.
``` terminal
$ sudo rails generate migration add_user_id_to_links user_id:integer:index
$ sudo rake db:migrate
```
>추가한 것을 확인합니다.
``` terminal
$ sudo rails c
$ Link.connection
$ Link
  => Link(id: integer, title: string, url: string, created_at: datetime, updated_at: datetime, user_id: integer)
```
>User가 링크를 생성할 때 User id가 해당 링크에 할당되도록 링크 컨트롤러를 업데이트합니다.    
>app/controller/links_controller.rb 안에 드를 수정합니다.    
>영상에는 'current_user.links.build'라고 적혀있지만 오류가 발생하여 'current_user.link.build'로 수정하였다.
``` rb
# before
def new
  @link = Link.new
end
#-------------중략-------------#
def create
  @link = Link.new(link_params)
#-----------이하 생략-----------#
# after
def new
  @link = current_user.link.build
end
#-------------중략-------------#
def create
  @link = current_user.link.build(link_params)
#-----------이하 생략-----------#
```
>작업이 잘 동작하는지 확인합니다.    
>link를 마지막으로 작성한 user id는 1입니다.    
>user id가 1인 사람을 확인합니다.
``` terminal
$ sudo rails c
@link = Link.last
  => Link id: 3, title: "Devise Gem", url: "https://rubygems.org/gems/devise", created_at: "2020-10-21 12:11:49", updated_at: "2020-10-21 12:11:49", user_id: 1
@link.user
  => User id: 1, email: "test@email.com", created_at: "2020-10-21 09:10:45", updated_at: "2020-10-21 09:10:45"
```
>몇 가지 인증을 추가하여 비인증자를 필터링합니다.    
>links_controller.rb에 before_action을 추가합니다.    
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
>Edit과 Destroy는 로그인을 하지 않으면 동작하지 않는것을 볼 수 있습니다.    
>하지만 다른 사용자가 로그인을 하면 Edit과 Destroy가 동작합니다.
>사용자가 로그인하지 않은 경우 Edit의 경로를 볼 수 없도록 app/views/links/index.html.erb를 수정합니다.
``` erb
<!-- before -->
<!-- 생략 -->
<td><%= link_to 'Show', link %></td>
<td><%= link_to 'Edit', edit_link_path(link) %></td>
<td><%= link_to 'Destroy', link, method: :delete, data: { confirm: 'Are you sure?' } %></td>
<!-- 이하 생략 -->
<!-- after -->
<!-- 생략 -->
<td><%= link_to 'Show', link %></td>
<% if link.user == current_user %>
  <td><%= link_to 'Edit', edit_link_path(link) %></td>
  <td><%= link_to 'Destroy', link, method: :delete, data: { confirm: 'Are you sure?' } %></td>
<% end %>
<!-- 이하 생략 -->
```
>레일즈 콘솔을 통하여 링크의 생성 User를 알 수 있다.    
>세 번째 링크 생성 User를 1로 바꾸어보자.
``` terminal
$ sudo rails c
$ @link = Link.third
  => Link id: 4, title: "Ruby on Rails", url: "https://rubyonrails.org", created_at: "2020-10-21 12:54:54", updated_at: "2020-10-21 12:54:54", user_id: 2
$ @link.user = User.first
  => User id: 1, email: "test@email.com", created_at: "2020-10-21 09:10:45", updated_at: "2020-10-21 09:10:45"
$ @link.save
$ @link = Link.third
  => Link id: 4, title: "Ruby on Rails", url: "https://rubyonrails.org", created_at: "2020-10-21 12:54:54", updated_at: "2020-10-21 12:57:48", user_id: 1
```
>세 번째 링크 소유자가 1로 바뀐 것을 확인할 수 있다.    
>레일즈 서버를 이용해서 user_id: 2로 로그인 한 뒤에 수정이 가능한지 확인해보자.
>app/views/links/index.html.erb 하단에서 다음 코드를 삭제합니다.
``` erb
<%= link_to 'New Link', new_link_path %>
```
- 2020-10-22
>부트스트랩을 추가하기 위하여 Gemfile을 수정하고 설치합니다.
``` gemfile
gem 'bootstrap-sass', '~> 3.4', '>=3.4.1'
```
``` terminal
sudo bundle install
```
>app/assets/stylesheets/application.css의 이름을 app/assets/stylesheets/application.scss로 변경합니다.    
>변경한 파일에 다음 내용을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>jquery-rails가 설치가 안되어 있다면 설치하기 위해 Gemfile을 수정하고 다음과 같이 실행합니다.
``` gemfile
gem 'jquery-rails'
```
``` terminal
sudo bundle install
```
>app/views/layouts/application.html.erb파일을 [Mackenzie](https://github.com/mackenziechild/raddit/blob/master/app/views/layouts/application.html.erb)에서 복사 붙여넣기 해줍니다.    
>스타일의 중복 정의를 막기 위해 scaffolds.scss 파일을 삭제합니다.    
>버전 차이로 인해 Pipeline 오류가 발생한다면 아래처럼 수정해주세요.
``` erb
<!-- before -->
<%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
<!-- after -->
<%= javascript_pack_tag 'application', 'data-turbolinks-track': true %>
```
>정상적으로 작동하는지 확인해봅니다.    
>정상적으로 작동했다면 app/assets/stylesheets/application.scss를 [Mackenzie](https://github.com/mackenziechild/raddit/blob/master/app/assets/stylesheets/application.css.scss)에서 복사 붙여넣기 해줍니다.    
>app/views/links/index.html.erb의 내용을 삭제하고 다음을 추가해줍니다.
``` erb
<% @links.each do |link| %>
<div class="link row clearfix">
  <h2>
    <%= link_to link.title, link %><br>
    <small class="author">Submitted <%= time_ago_in_words(link.created_at) %> by <%= link.user.email %></small>
  </h2>
</div>
<% end %>
```
>app/views/links/show.html.erb의 내용을 삭제하고 다음을 추가해줍니다.
``` erb
<div class="page-header">
  <h1>
    <a href="<%= @link.url %>"><%= @link.title %></a><br>
    <small>Submitted by <%= @link.user.email %></small>
  </h1>
</div>
<div class="btn-group">
  <%= link_to 'Visit URL', @link.url, class: "btn btn-primary" %>
</div>
<% if @link.user == current_user %>
  <div class="btn-group">
    <%= link_to 'Edit', edit_link_path(@link), class: "btn btn-default" %>
    <%= link_to 'Destroy', @link, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-default" %>
  </div>
<% end %>
```
>추가를 하고 잘 적용이 되었는지 링크를 클릭하여 확인해봅니다.    
>잘 동작하는 것을 확인했으면 app/views/links/_form.html.erb의 내용을 수정합니다.
``` erb
<!-- before -->
<div class="field">
  <%= form.label :title %>
  <%= form.text_field :title %>
</div>

<div class="field">
  <%= form.label :url %>
  <%= form.text_field :url %>
</div>

<div class="actions">
  <%= form.submit %>
</div>
<!-- after -->
<div class="form-group">
  <%= form.label :title %><br>
  <%= form.text_field :title, class: "form-control" %>
</div>

<div class="form-group">
  <%= form.label :url %><br>
  <%= form.text_field :url, class: "form-control" %>
</div>

<div class="actions">
  <%= form.submit "Submit", class: "btn btn-kg btn-primary" %>
</div>
```
>Submit link가 잘 동작하는지 확인합니다.    
>app/views/devise/registrations/edit.html.erb를 수정합니다.
``` erb
<!-- before -->
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>

<% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
  <div>Currently waiting confirmation for: <%= resource.unconfirmed_email %></div>
<% end %>

<div class="field">
  <%= f.label :password %> <i>(leave blank if you don`t want to change it)</i><br />
  <%= f.password_field :password, autocomplete: "new-password" %>
  <% if @minimum_password_length %>
    <br />
    <em><%= @minimum_password_length %> characters minimum</em>
  <% end %>
</div>

<div class="field">
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation, autocomplete: "new-password" %>
</div>

<div class="field">
  <%= f.label :current_password %> <i>(we need your current password to confirm your changes)</i><br />
  <%= f.password_field :current_password, autocomplete: "current-password" %>
</div>

<div class="actions">
  <%= f.submit "Update" %>
</div>
<% end %>

<h3>Cancel my account</h3>

<p>Unhappy? <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete %></p>

<%= link_to "Back", :back %>

<!-- after -->
<div class="panel panel-default">
  <div class="panel-body">
    <div class="form-inputs">
      <div class="form-group">
        <%= f.label :email %>
        <%= f.email_field :email, class: "form-control", :autofocus => true %>
      </div>

      <div class="form-group">
        <%= f.label :password %><i>(leave blank if you don't want to change it</i>
        <%= f.password_field :password, class: "form-control", :autocomplete => "off" %>
      </div>

      <div class="form-group">
        <%= f.label :current_password %><i>(we need your current password to confirm your changes</i>
        <%= f.password_field :current_password, class: "form-control" %>
      </div>
    </div>

    <div class="form-group">
      <%= f.submit "Update", class: "btn btn-primary" %>
    </div>
    <% end %>
  </div>

  <div class="panel-footer">
    <h3>Cancel my account</h3>
    <p>Unhappy? <%= button_to "Cancel my account", registration_path(resource_name), data: { confirm: "Are you sure?" }, method: :delete, class: "btn btn-default" %></p>
  </div>
</div>
```
>계정 수정 페이지가 잘 동작하는지 확인합니다.    
>동작이 잘 된다면 app/views/devise/registrations/new.html.erb를 수정합니다.
``` erb
<!-- before -->
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>

<div class="field">
  <%= f.label :password %>
  <% if @minimum_password_length %>
    <em>(<%= @minimum_password_length %> characters minimum)</em>
  <% end %><br />
  <%= f.password_field :password, autocomplete: "new-password" %>
</div>

<div class="field">
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation, autocomplete: "new-password" %>
</div>

<div class="actions">
  <%= f.submit "Sign up" %>
</div>

<!-- after -->
<div class="form-group">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, class: "form-control", required: true %>
</div>

<div class="form-group">
  <%= f.label :password %>
  <%= f.password_field :password, class: "form-control", required: true %>
</div>

<div class="form-group">
  <%= f.label :password_confirmation %><br />
  <%= f.password_field :password_confirmation, class: "form-control", required: true %>
</div>

<div class="form-group">
  <%= f.submit "Sign up", class: "btn btn-lg btn primary" %>
</div>
```
>계정 생성 페이지가 잘 동작하는지 확인합니다.    
>잘 동작한다면 app/views/devise/sessions/new.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>

<div class="field">
  <%= f.label :password %><br />
  <%= f.password_field :password, autocomplete: "current-password" %>
</div>

<% if devise_mapping.rememberable? %>
  <div class="field">
    <%= f.check_box :remember_me %>
    <%= f.label :remember_me %>
  </div>
<% end %>

<div class="actions">
  <%= f.submit "Log in" %>
</div>
<!-- after -->
<div class="form-group">
  <%= f.label :email %>
  <%= f.email_field :email, autofocus: true, class: "form-control", required: false %>
</div>

<div class="form-group">
  <%= f.label :password %>
  <%= f.password_field :password, class: "form-control", required: false %>
</div>

<div class="checkbox">
  <label>
    <%= f.check_box :remember_me, required: false, as: :boolean if devise_mapping.rememberable? %> Remember Me
  </label>
</div>

<div class="form=group">
  <%= f.submit "Log in", class: "btn btn-primary" %>
</div>
```
>투표 시스템을 만들기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'acts_as_votable', '~> 0.12.1'
```
``` terminal
sudo gem install acts_as_votable
```
>투표를 저장할 테이블을 만들고 마이그레이션합니다.
``` terminal
sudo rails generate acts_as_votable:migration
sudo rake db:migrate
```
>app/models/link.rb에 다음 항목을 추가합니다.
``` rb
acts_as_votable
```
>잘 동작하는지 확인하기 위해 레일즈 콘솔을 이용하여 확인합니다.
``` terminal
$ sudo rails c
$ @link = Link.first
$ @user = User.first
$ @link.votes_for.size
$ @link.save
```
>투표를 볼 수 있도록 app/config/route.rb로 이동하여 다음을 추가합니다.
``` rb
# before
resources :links
# after
resources :links do
  member do
    put "like", to: "links#upvote"
    put "dislike", to: "links#downvote"
  end
end
```
>app/controller/links_controllers.rb에서 다음 메서드를 추가합니다.
``` rb
# upvote
def upvote
  @link = Link.find(params[:id])
  @link.upvote_by current_user
  redirect_to fallback_location: '/'
end
# downvote
def downvote
  @link = Link.find(params[:id])
  @link.downvote_by current_user
  redirect_to fallback_location: '/'
end
```
>app/views/links/index.html.erb에서 Upvote와 Downvote 버튼을 추가합니다.
``` erb
<!-- before -->
<!-- 생략 -->
  </h2>
</div>
<% end %>
<!-- after -->
<!-- 생략 -->
  </h2>
  <div class="btn-group">
    <a class="btn btn-default btn-sm" href="<%= link.url %>">Visit Link</a>
    <%= link_to like_link_path(link), method: :put, class: "btn btn-default btn-sm" do %>
      <span class="glyphicon glyphicon-chevron-up"></span>
      Upvote
      <%= link.get_upvotes.size %>
    <% end %>
    <%= link_to dislike_link_path(link), method: :put, class: "btn btn-default btn-sm" do %>
      <span class="glyphicon glyphicon-chevron-down"></span>
      Downvote
      <%= link.get_downvotes.size %>
    <% end %>
  </div>
</div>
<% end %>
```
>app/views/links/show.html.erb에 Upvote와 Downvote 기능을 추가하기 위해 다음을 추가합니다.
``` erb
<div class="btn-group pull-right">
  <%= link_to like_link_path(@link), method: :put, class: "btn btn-default btn-sm" do %>
    <span class="glyphicon glyphicon-chevron-up"></span>
    Upvote
    <%= @link.get_upvotes.size %>
  <% end %>
  <%= link_to dislike_link_path(@link), method: :put, class: "btn btn-default btn-sm" do %>
    <span class="glyphicon glyphicon-chevron-up"></span>
    Downvote
    <%= @link.get_downvotes.size %>
  <% end %>
</div>
```
- 2020-10-23
>댓글 기능을 추가하기 위해 아래와 같이 스카폴드를 수행하고 마이그레이션을 해줍니다.    
>정상적으로 동작하는지 서버를 실행해서 확인해봅니다.
``` terminal
$ sudo rails generate scaffold Comment link_id:integer:index body:text user:references
$ sudo rake db:migrate
```
>comment를 사용하기 위한 simple_form을 설치하기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'simple_form'
```
``` terminal
sudo bundle install
```
>app/models/comment.rb 파일에 다음을 추가해줍니다.
``` rb
belongs_to :link
```
>app/models/link.rb 파일에 다음을 추가해줍니다.
``` rb
has_many :comments
```
>config/routes.rb 파일을 다음과 같이 수정해줍니다.
``` rb
# before
resources :links do
  member do
    put "like", to: "links#upvote"
    put "dislike", to: "links#downvote"
  end
end
# after
resources :links do
  member do
    put "like", to: "links#upvote"
    put "dislike", to: "links#downvote"
  end
  resources :comments
end
```
>create에 메서드를 추가하기 위해 app/controllers/comments_controller.rb 파일을 수정해줍니다.
``` rb
# before
@comment = Comment.new(comment_params)
# after
@link = Link.find(params[:link_id])
@comment = @link.comments.new(comment_params)
@comment.user = current_user
```
>app/views/links/show.html.erb 파일 하단에 다음을 추가해줍니다.
``` erb
<h3 class="comments_title">
  <%= @link.comments.count %> comments
</h3>

<div id="comments">
  <%= render :partial => @link.comments %>
</div>
<%= simple_form_for [@link, Comment.new] do |f| %>
  <div class="field">
    <%= f.text_area :body, class: "form-control" %>
  </div>
  <br>
  <%= f.submit "Add Comment", class: "btn btn-primary" %>
<% end %>
```
>렌더링을 위한 페이지를 만들기 위해 app/views/comments에 다음을 포함한 _comment.html.erb를 만들어줍니다.
``` erb
<%= div_for(comment) do %>
  <div class="comments_wrapper clearfix">
    <div class="pull-left">
      <p class="lead"><%= comment.body %></p>
      <p><small>Submitted <strong><%= time_ago_in_words(comment.created_at) %> ago</strong> by <%= comment.user.email %></small></p>
    </div>

    <div class="btn-group pull-right">
      <% if comment.user == current_user %>
        <%= link_to 'Destroy', comment, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-sm btn-default" %>
      <% end %>
    </div>
  </div>
<% end %>
```
>div_for를 작동시키기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'record_tag_helper', '~> 1.0', '>= 1.0.1'
```
``` terminal
sudo gem install record_tag_helper
```
>잘 동작하는지 확인하기 링크를 클릭하여 확인합니다.
>app/views/links/index.html.erb의 오타를 수정합니다.
``` erb
# before
small class="author">Submitted <%= time_ago_in_words(link.created_at) %> by <%= link.user.email %></small>
# after
small class="author">Submitted <%= time_ago_in_words(link.created_at) %> ago by <%= link.user.email %></small>
```
>가입시 사용자 이름을 추가하기 위해 다음을 마이그레이션하고 app/views/devise/registration/edit.html.erb에 다음을 추가합니다.
``` terminal
$ sudo rails generate migration add_name_to_users name:string
$ sudo rake db:migrate
```
``` erb
<div class="form-group">
  <%= f.label :name %>
  <%= f.text_field :name, class: "form-control", :autofocus => true %>
</div>
```
>app/controllers/application_controller.rb를 다음과 같이 수정합니다.
``` rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
```
>app/controllers/views/links/index.html.erb를 수정해줍니다.
``` erb
<!-- before -->
<small class="author">Submitted <%= time_ago_in_words(link.created_at) %> ago by <%= link.user.email %></small>
<!-- after -->
<small class="author">Submitted <%= time_ago_in_words(link.created_at) %> ago by <%= link.user.name %></small>
```
>app/controllers/views/links/show.html.erb를 수정해줍니다.
``` erb
<!-- before -->
<small>Submitted by <%= @link.user.email %></small>
<!-- after -->
<small>Submitted by <%= @link.user.name %></small>
```
>app/controllers/views/comments/_comment.html.erb를 수정해줍니다.
``` erb
<!-- before -->
<p><small>Submitted <strong><%= time_ago_in_words(comment.created_at) %> ago</strong> by <%= comment.user.email %></small></p>
<!-- after -->
<p><small>Submitted <strong><%= time_ago_in_words(comment.created_at) %> ago</strong> by <%= comment.user.name %></small></p>
```
>app/controllers/views/devise/registrations/new.html.erb를 추가해줍니다.
``` erb
<div class="form-group">
  <%= f.label :name %>
  <%= f.text_field :name, class: "form-control", :autofocus => true %>
</div>
```
>이로써 link 작성자, comment 작성자를 이메일이 아닌 이름으로 표시하게 되었습니다.    
>Reddit Clone 프로젝트를 마칩니다.    
---    
## Blog
- 2020-10-24
>레일즈 프로젝트를 생성합니다.    
>프로젝트 폴더로 이동합니다.
``` terminal
$ sudo rails new blog
$ cd blog/
```
>레일즈 서버를 켜서 잘 동작하는지 확인합니다.
``` terminal
$ sudo rails server
```
>post 컨트롤러를 생성합니다.
``` terminal
$ sudo rails generate controller posts
```
>경로 설정을 위해 app/config/routes.rb에 다음을 추가합니다.    
>index를 정의하기 위해 app/controllers/posts/posts_controller.rb에 다음을 추가합니다.    
>app/views/posts/index.html.erb 파일을 만들어 다음을 추가합니다.
``` rb
# routes.rb
resources : posts
root "posts#index"
```
``` rb
# posts_controller.rb
def index
end
```
``` erb
<!-- index.html.erb -->
<h1>This is the index.html.erb file... Yay!</h1>
```
>잘 동작하는지 확인해줍니다.    
>post를 새로 만드는 것을 구현하기 위해 app/controllers/posts/posts_controller.rb에 다음을 추가합니다.    
>post를 새로 만들 수 있도록 app/views/posts/new.html.erb 파일을 만들어 다음을 추가합니다.
``` rb
def new
end
```
``` erb
<h1>New Post</h1>

<%= form_for :post, url: posts_path do |f| %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
```
>post 모델을 생성하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Post title:string body:text
$ sudo rake db:migrate
```
>app/controller/posts_controller.rb에 create와 show, private 메소드를 추가합니다.    
>생성한 post를 볼 수 있는 페이지를 위해 app/views/posts/show.html.erb 생성하고 코드를 추가해줍니다.
``` rb
def create
  @post = Post.new(post_params)
  @post.save

  redirect_to @post
end

private
  def post_params
    params.require(:post).permit(:title, :body)
  end
```
``` erb
<h1 class="title">
  <%= @post.title %>
</h1>

<p class="date">
  Submitted <%= time_ago_in_words(@post.created_at) %> Ago
</p>

<p class="body">
  <%= @post.body %>
</p>
```
>index에서 post를 확인하기 위해 app/controller/posts_controller.rb를 다음과 같이 수정해줍니다.    
>app/views/posts/index.html.erb를 다음과 같이 수정해줍니다.
``` rb
# before
def index
end
# after
def index
  @posts = Post.all.order('Created_at DESC')
end
```
``` erb
<% @posts.each do |post| %>
  <div class="post_wrapper">
    <h2 class="title"><%= link_to post.title, post %></h2>
    <p class="date"><%= post.created_at.strftime("%B, %d, %Y") %></p>
  </div>
<% end %>
```
>블로그 스타일링을 위해 app/views/layouts/application.html.erb를 추가해줍니다.    
>app/assets/images/logo.svg를 추가해줍니다.    
>app/assets/stylesheets/application.css 를 [application.scss](https://github.com/mackenziechild/blog/blob/master/app/assets/stylesheets/application.css.scss)을 이용하여 수정하고, app/assets/stylesheets/_normalize.scss를 추가하고 [_normalize.scss](https://github.com/mackenziechild/blog/blob/master/app/assets/stylesheets/_normalize.css.scss)를 이용하여 수정해줍니다.
``` erb
<!-- 생략 -->
<%= stylesheet_link_tag 'application', 'http://fonts.googleapis.com/css?family=Raleway:400,700' %>
<!-- 중략 -->
<div id="sidebar">
  <div id="logo">
    <%= link_to root_path do %>
      <%= image_tag "logo.svg" %>
    <% end %>
  </div>

  <ul>
    <li class="category">Website</li>
    <li><%= link_to "Blog", root_path %></li>
    <li>About</li>
  </ul>

  <ul>
    <li class="category">Social</li>
    <li><a href="">Twitter</a></li>
    <li><a href="http://instagram.com/p_xzhu">Instagram</a></li>
    <li><a href="https://github.com/pxzhu">Github</a></li>
    <li><a href="mailto:wearan0nsgat@gmail.com">Email</a></li>
  </ul>

  <p class="sign_in">Admin Login</p>
</div>
<div id="main_content">
  <div id="header">
    <p>All Posts</p>

    <div class="buttons">
      <button class="button"><%= link_to "New Post", new_post_path %></button>
      <button class="button">Log Out</button>
    </div>
  </div>

  <% flash.each do |name, msg| %>
    <%= content_tag(:div, msg, class: "alert") %>
  <% end %>

  <%= yield %>
</div>
```
>새 post의 디자인을 바꾸기 위해 app/views/posts/new.html.erb를 전체적으로 묶어줍니다.
``` erb
<div id="page_wrapper">
  <!-- 중략 -->
</div>
```
>post 목록의 디자인을 바꾸기 위해 app/views/posts/show.html.erb를 전체적으로 묶어줍니다.
``` erb
<div id="post_conetnt">
  <!-- 중략 -->
</div>
```
>post를 작성할 때 빈칸으로 완료하거나 제목 길이가 너무 짧지 않게 하기 위해 app/models/post.rb에 다음을 추가해줍니다.    
> app/controllers/posts_controller.rb의 new 메소드와 create 메소드를 수정해줍니다.
``` rb
validates :title, presence: true, length: { minimum: 5 }
validates :body, presence: true
```
``` rb
# before
def new
end
def create
  @post = Post.new(post_params)
  @post.save

  redirect_to @post
end
# after
def new
    @post = Post.new
  end
def create
  @post = Post.new(post_params)

  if @post.save
    redirect_to @post
  else
    render 'new'
  end
end
```
>post 작성 시 오류가 발생하면 오류를 알려주는 것을 만들기 위해 app/views/posts/new.html.erb에 다음을 추가해줍니다.
``` erb
<!-- 생략 -->
<%= form_for :post, url: posts_path do |f| %>
  <% if @post.errors.any? %>
    <div id="errors">
      <h2><%= pluralize(@post.errors.count, "error") %> pervented this post from saving</h2>
      <ul>
        <% @post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>>
        <% end %>
      </ul>
    </div>
  <% end %>
  <p>
<!-- 이하 생략 -->
```
>post 수정을 위해 app/controllers/posts_controller.rb에 다음을 추가합니다.
``` rb
# 생략
def edit
  @post = Post.find(params[:id])
end
def update
  @post = Post.find(params[:id])  

  if @post.update(params[:post].permit(:title, :body))
    redirect_to @post
  else
    render 'edit'
  end
end
# 이하 생략
```
>app/views/posts/_form.html.erb 파일을 만들고 다음을 추가합니다.    
``` erb
<%= form_for @post do |f| %>
  <% if @post.errors.any? %>
    <div id="errors">
      <h2><%= pluralize(@post.errors.count, "error") %> pervented this post from saving</h2>
      <ul>
        <% @post.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>>
        <% end %>
      </ul>
    </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>

  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>

  <p>
    <%= f.submit %>
  </p>
<% end %>
```
>app/views/posts/new.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div id="page_wrapper">
  <h1>New Post</h1>

  <%= render 'form' %>
</div>
```
>app/views/posts/edit.html.erb 파일을 만들고 다음을 추가합니다.
``` erb
<div id="page_wrapper">
  <h1>New Post</h1>

  <%= render 'form' %>
</div>
```
>app/views/posts/show.html.erb 파일에 다음을 추가합니다.
``` erb
<!-- 생략 -->
Submitted <%= time_ago_in_words(@post.created_at) %> Ago
| <%= link_to 'Edit', edit_post_path(@post) %>
<!-- 이하 생략 -->
```
>post 삭제를 위해 app/controllers/posts_controller.rb에 다음을 추가합니다.
``` rb
# 생략
def destroy
  @post = Post.find(params[:id])
  @post.destroy

  redirect_to root_path
end
# 이하 생략
```
>app/views/posts/show.html.erb 파일에 다음을 추가합니다.
<!-- 생략 -->
| <%= link_to 'Edit', edit_post_path(@post) %>
| <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?' } %>
<!-- 이하 생략 -->
```
>comment 기능을 추가하고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Comment name:string body:text post:references
$ sudo rake db:migrate
```
>app/models/post.rb에 다음을 추가합니다.
``` rb
has_many :comments
```
>post가 존재할 때 comment가 존재하도록 config/route.rb를 수정해줍니다.
``` rb
# before
resources :posts
root "posts#index"
# after
resources :posts do
  resources :comments
end
root "posts#index"
```
>comment의 controller를 생성해줍니다.
``` terminal
$ sudo rails generate controller Comments
```
>comment가 동작할 수 있도록 app/controllers/comments_controller.rb 파일에 다음을 추가해줍니다.
``` rb
def create
  @post = Post.find(params[:post_id])
  @comment = @post.comments.create(params[:comment].permit(:name, :body))

  redirect_to post_path(@post)
end
```
>app/views/comments/_comment.html.erb와 _form.html.erb를 생성해줍니다.    
>_form.html.erb에 다음과 같이 폼을 만들어줍니다.
``` erb
<%= form_for([@post, @post.comments.build]) do |f| %>
  <p>
    <%= f.label :name %><br>
    <%= f.text_field :name %>
  </p>
  <p>
    <%= f.label :body %><br>
    <%= f.text_area :body %>
  </p>
  <br>
  <p>
    <%= f.submit %>
  </p>
<% end %>
```
>_comment.html.erb에 다음과 같이 디자인을 해줍니다.
``` erb
<div class="comment clearfix">
  <div class="comment_content">
    <p class="comment_name"><strong><%= comment.name %></strong></p>
    <p class="comment_body"><%= comment.body %></p>
    <p class="comment_time"><%= time_ago_in_words(comment.created_at) %> Ago</p>
  </div>
</div>
```
>post에 comment를 작성할수 있는 폼을 추가하기 위해 app/views/posts/show.html.erb에 다음을 추가해줍니다.
``` erb
<!-- 생략 -->
  <div id="comments">
    <h2><%= @post.comments.count %> Comments</h2>
    <%= render @post.comments %>

    <h3>Add a comment: </h3>
    <%= render "comments/form" %>
  </div>
</div>
```
>comment 삭제 기능을 위해 app/controllers/comments_controller.rb 파일에 다음을 추가합니다.
``` rb
def destroy
  @post = Post.find(params[:post_id])
  @comment = @post.comments.find(params[:id])
  @comment.destroy

  redirect_to post_path(@post)
end
```
>comment 삭제 버튼을 만들기 위해 app/views/comments/_comment.html.erb 파일에 다음을 추가합니다.
``` erb
<p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?' } %></p>
```
>destroy 메소드를 동작하게 하기 위해서 app/models/post.rb를 다음과 같이 수정합니다.
``` rb
# before
has_many :comments
# after
has_many :comments, dependent: :destroy
```
>About을 사용하기 위해 pages 컨트롤러를 생성합니다.
``` terminal
$ sudo rails generate controller pages
```
>about 메소드를 정의하기 위해 app/controllers/pages_controller.rb 파일에 다음을 추가합니다.
``` rb
def about
end
```
>경로를 설정하기 위해 config/routes.rb 파일에 다음을 추가해줍니다.
``` rb
# 생략
get '/about'. to: 'pages#about'
```
>app/views/pages/about.html.erb 파일에 다음을 추가하여 about 페이지를 만들어줍니다.
``` erb
<div id="page_wrapper">
  <div id="profile_image">
    <%= image_tag "profile.jpeg" %>
  </div>

  <div id="content">
    <h1>Hey, I'm Pxzhu</h1>
    <p>Welcome to week 2 of my 12 Web Apps Challenge.</p>
    <p>This Challenge is I built a blog in Rails. You're actually on the demo application right now. Cool stuff, right!</p>
    <p>If you'd like to follow along as I learn more Ruby on Rails, find me on Github <a href="https://github.com/pxzhu">pxzhu</a> or Email to <a herf="mailto:wearan0nsgat@gmail.com">HERE!</a></p>
  </div>
</div>
```
>About 버튼 활성화를 위해 app/views/layouts/application.html.erb 파일의 다음을 수정합니다.
``` erb
<!-- before -->
<li>About</li>
<!-- after -->
<li><%= link_to "About", about_path %></li>
```
>About 화면일 때, post 화면일 때 header의 정보를 바꿔주기 위하여 app/views/layouts/application.html.erb 파일의 다음을 수정합니다.
``` erb
<!-- before -->
<div id="header">
  <p>All Posts</p>
<!-- after -->
<div id="header">
  <% if current_page?(root_path) %>
    <p>All Posts</p>
  <% elsif current_page?(about_path) %>
    <p>About</p>
  <% else %>
    <%= link_to "Back to All Posts", root_path %>
  <% end %>
```
>로그인 기능을 사용하기 위해 devise를 설치합니다.    
>devise 설치를 위해 Gemfile에 다음을 추가해줍니다.    
>devise를 설치해줍니다.
``` gemfile
gem 'deivse'
```
``` terminal
$ sudo bundle install
```
>레일즈 서버를 켠 상태로 devise를 설치해줍니다.    
>다음을 복사한 뒤 config/environments/development.rb 하단에 추가해줍니다.    
``` terminal
$ sudo rails generate devise:install
  => ...
    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    ...
```
>devise의 views도 생성해줍니다.    
>User도 생성한 뒤 마이그레이션해줍니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>다음 주소에서 페이지가 잘 동작하는지 확인하고 회원가입을 합니다.
```
localhost:3000/users/sign_up
```
>app/views/devise/sessions/new.html.erb에서 최상단과 최하단에 다음을 추가해줍니다.    
>중간중간 보기 좋게 줄 바꿈 태그도 넣어줍니다.
``` erb
<div id="page_wrapper">
</div>
```
>app/controllers/posts_controller.rb 상단에 다음을 추가합니다.
``` rb
before_action :authenticate_user!, except: [:index, :show]
```
>로그인한 user만 Log Out이 표시되게 app/views/layouts/application.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
<div class="buttons">
  <button class="button"><%= link_to "New Post", new_post_path %></button>
  <button class="button">Log Out</button>
</div>
<!-- after -->
<% if user_signed_in? %>
  <div class="buttons">
    <button class="button"><%= link_to "New Post", new_post_path %></button>
    <button class="button">Log Out</button>
  </div>
<% end %>
```
>로그인하지 않은 user만 Admin Login이 표시되게 다음과 같이 수정합니다.
``` erb
<!-- before -->
<p class="sign_in">Admin Login</p>
<!-- after -->
<% if !user_signed_in? %>
  <p class="sign_in">Admin Login</p>
<% end %>
``` 
>로그인한 user만 post를 수정, 삭제할 수 있게 하기 위하여 app/views/posts/show.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
| <%= link_to 'Edit', edit_post_path(@post) %>
| <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?' } %>
<!-- after -->
<% if user_signed_in? %>
  | <%= link_to 'Edit', edit_post_path(@post) %>
  | <%= link_to 'Delete', post_path(@post), method: :delete, data: { confirm: 'Are you sure?' } %>
<% end %>
```
>로그인한 user만 comment를 삭제할 수 있게 하기 위하여 app/views/comments/_comment.html.erb를 다음과 같이 수정합니다.
``` erb
<!-- before -->
<p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?' } %></p>
<!-- after -->
<% if user_signed_in? %>
  <p><%= link_to 'Delete', [comment.post, comment], method: :delete, class: 'button', data: { confirm: 'Are you sure?' } %></p>
<% end %>
<% end %>
```
---    

## Recipe Box
- 2020-10-25
>레일즈 프로젝트를 생성합니다.    
>프로젝트 폴더로 이동합니다.    
>서버를 켜서 잘 동작하는지 확인합니다.
``` terminal
$ sudo rails new recipe_box
$ cd recipe_box/
$ sudo rails server
```
>html 대신 사용하기 위해 Gemfile에 haml을 추가하고 설치해줍니다.
``` gemfile
gem 'haml', '~> 5.2'
```
``` terminal
$ gem install haml
```
>recipe 컨트롤러를 생성합니다.    
``` terminal
$ sudo rails generate controller recipes
```
>config/routes.rb 파일에 다음을 추가하여 경로를 설정합니다.
``` rb
resources :recipes

root "recipes#index"
```
>app/controllers/recipes_controller.rb 파일에 다음을 추가해줍니다.    
>app/views/recipes/index.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` rb
before_action :find_recipe, only: [:show, :edit, :update, :destroy]

def index
end
def show
end
def new
  @recipe = Recipe.new
end
def create
  @recipe = Recipe.new(recipe_params)

  if @recipe.save
    redirect_to @recipe, notice: "Successfully created new recipe"
  else
    render 'new'
  end
end

private

def recipe_params
  params.require(:recipe).permit(:title, :description)
end
def find_recipe
  @recipe = Recipe.find(params[:id])
end
```
``` haml
%h1 This is the placeholder for the Recipes#Index
```
>Recipe 모델을 만들고 마이그레이션 해줍니다.
``` terminal
$ sudo rails generate model Recipe title:string description:text user_id:integer
$ sudo rake db:migrate
```
>app/views/recipes 폴더에 _form.html.haml 과 new.html.haml 파일을 생성해줍니다.    
>Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'simple_form', '~> 5.0', '>= 5.0.3'
```
``` terminal
$ sudo gem install simple_form
```
>app/views/recipes/_form.html.haml 파일에 다음을 추가합니다.    
>app/views/recipes/new.html.haml 파일에 다음을 추가합니다.
``` haml
= simple_form_for @recipe, html: { multipart: true } do |f|
  - if @recipe.errors.any?
    #errors
      %p
        = @recipe.errors.count
        Prevented this recipe froms saving
      %ul
        - @recipe.errors.full_messages.each do |msg|
          %li= msg
  .panel-body
    = f.input :title, input_html: { class: 'form-control' }
    = f.input :description, input_html: { class: 'form-control' }

  = f.button :submit, class: "btn btn-primary"
```
``` haml
%h1 New Recipe

= render 'form'

%br

= link_to "Back", root_path, class: "btn btn-default"
```
>만들어진 recipe를 보기 위해 app/views/recipes/show.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
%h1= @recipe.title
%p= @recipe.description

= link_to "Back", root_path, class: "btn btn-default"
```
>index 화면에서 레시피 링크를 볼 수 있도록 app/controllers/recipes_controller.rb 파일의 다음을 수정해줍니다.    
>app/views/recipres/index.html.haml 파일도 수정해줍니다.
``` rb
# before
def index
end
# after
def index
  @recipe = Recipe.all.order("created_at DESC")
end
```
``` haml
- @recipe.each do |recipe|
  %h3= link_to recipe.title, recipe
```
>수정과 삭제 기능을 위해 app/controllers/recipes_controller.rb 파일에 다음을 추가해줍니다.    
``` rb
def edit
end
def update
  if @recipe.update(recipe_params)
    redirect_to @recipe
  else
    render 'edit'
  end
end
def destroy
  @recipe.destroy
  redirect_to root_path, notice: "Successfully deleted recipe"
end
```
>수정 화면을 구현하기 위해 app/views/recipes 폴더에 edit.html.haml 파일을 만들고 다음을 추가해줍니다.
``` haml
%h1 Edit Recipe

=render 'form'
```
>app/views/recipres/show.html.haml 파일에 다음을 추가해줍니다.
``` haml
= link_to "Edit", edit_recipe_path, class: "btn btn-default"
= link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>bootstrap-sass 설치를 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
```
``` terminal
$ sudo gem install bootstrap-sass
```
>app/assets/stylesheets/application.css 파일을 application.scss로 이름을 변경하고 다음을 추가해줍니다.    
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>app/views/layouts/application.html.erb 파일을 application.html.haml로 이름을 변경하고 다음처럼 수정해줍니다.
``` haml
!!! 5
%html
%head
  %title Recipe App
  = csrf_meta_tags
  = csp_meta_tag

  = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
  = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

%body
  %nav.navbar.navbar-default
    .container
      .navbar-brand= link_to "Recipe Box", root_path

      %ul.nav.navbar-nav.navbar-right
        %li= link_to "New Recipe", new_recipe_path
        %li= link_to "Sign Out", root_path

  .container
    - flash.each do |name, msg|
      = content_tag :div, msg, class: "alert"
    = yield
```
>paperclip을 설치하기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'paperclip', '~> 6.1'
```
``` terminal
$ sudo gem install paperclip
```
>app/models/recipe.rb 파일에 다음을 추가합니다.
``` rb
has_attached_file :image, styles: { :medium => "400x400#" }
validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
```
>paperclip을 생성하고 마이그레이션해줍니다.    
>오류 발생 시 db/migrate 폴더에 있는 add_attachment_image_to_recipes.rb 파일을 다음과 같이 수정합니다.
``` terminal
$ sudo rails generate paperclip recipe image
$ sudo rake db:migrate
```
``` rb
# before
class AddAttachmentImageToRecipes < ActiveRecord::Migration
# after
class AddAttachmentImageToRecipes < ActiveRecord::Migration[6.0]
```
>app/views/recopes/_form.html.haml 파일에 다음을 추가해줍니다.
``` haml
= f.input :iamge, input_html: { class: 'form-control' }
```
>app/controllers/recipes_controller.rb 파일을 다음과 같이 수정해줍니다.
``` rb
# before
def recipe_params
  params.require(:recipe).permit(:title, :description)
end
# after
def recipe_params
  params.require(:recipe).permit(:title, :description, :image)
end
```
>잘 동작하는지 확인해봅니다.    
>잘 동작한다면 app/views/recipes/show.html.haml 파일 최상단에 다음을 추가합니다.
``` haml
= image_tag @recipe.image.url(:medium, class: "recipe_image")
```
>index 화면에도 image를 표시하기 위해  app/views/recipres/index.html.haml 파일을 다음과 같이 수정합니다.
``` haml
# before
- @recipe.each do |recipe|
  %h3= link_to recipe.title, recipe
# after
- @recipe.each do |recipe|
  = link_to recipe do
    = image_tag recipe.image.url(:medium)
  %h3= link_to recipe.title, recipe
```
>app/assets/stylesheets/application.scss 파일을 [여기](https://github.com/mackenziechild/recipe_box/blob/master/app/assets/stylesheets/application.css.scss)를 참고하여 스타일을 붙여 넣어줍니다.    
>coccon을 설치하기 위해 Gemfile을 수정하고 설치해줍니다.
``` gemfile
gem 'cocoon', '~> 1.2', '>= 1.2.15'
```
``` terminal
$ sudo gem install cocoon
```
>cocoon을 불러오기 위해 app/javascript/packs/application.js 파일에 다음을 추가해줍니다.    
>모델을 생성해줍니다.
``` js
require("jquery")
require("@nathanvda/cocoon")
```
``` terminal
$ sudo rails generate model Ingredient name:string recipe:belongs_to
$ sudo rails generate model Direction step:text recipe:belongs_to
$ sudo rake db:migrate
```
>app/models/recipe.rb 파일에 다음을 추가합니다.
``` rb
has_many :infredients
has_many :directions

accepts_nested_attributes_for :ingredients,
                              reject_if: proc { |attributes| attributes['name'].blank? },
                              allow_destroy: true
accepts_nested_attributes_for :directions,
                              reject_if: proc { |attributes| attributes['step'].blank? },
                              allow_destroy: true

validates :title, :description, :image, presence: true
```
>app/controllers/recipes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
params.require(:recipe).permit(:title, :description, :image)
# after
params.require(:recipe).permit(:title, :description, :image, ingredients_attributes: [:id, :name, :_destroy], directions_attributes: [:id, :step, :_destroy])
```
>app/views/recipes/_form.html.haml 파일에 다음을 추가합니다.
``` haml
<!-- 생략 -->
.row
  .col-md-6
    %h3 Ingredients
    #ingredients
      = f.simple_fields_for :ingredients do |ingredient|
        = render 'ingredient_fields', f: ingredient
      .links
        = link_to_add_association 'Add Ingredient', f, :ingredients, class: "btn btn-default add-button"
  .col-md-6
    %h3 Directions
    #directions
      = f.simple_fields_for :directions do |direction|
        = render 'direction_fields', f: direction
      .links
        = link_to_add_association 'Add Step', f, :directions, class: "btn btn-default add-button"
<!-- 이하 생략 -->
```
>app/views/recipes/_ingredient_fields.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
.form-inline.clearfix
  .nested-fields
    = f.input :name, input_html: { class: 'form-input form-control' }
    = link_to_remove_association "Remove", f, class: "form-button btn btn-default"
```
>app/views/recipes/_derection_fields.html.haml 파일을 만들고 다음을 추가합니다.
``` haml
.form-inline.clearfix
  .nested-fields
    = f.input :step, input_html: { class: 'form-input form-control' }
    = link_to_remove_association "Remove Step", f, class: "btn btn-default form-button"
```
>cocoon이 제대로 작동하지 않을 것입니다.    
>다음을 실행합니다.
``` terminal
$ sudo yarn add cocoon-js
```
>app/javascripts/packs/application.js 파일에 다음을 추가합니다.
``` js
import 'cocoon-js';
```
>app/views/recipes/show.html.haml 파일을 다음과 같이 수정합니다.
``` haml
.main_content
  #recipe_top.row
    .col-md-4
      = image_tag @recipe.image.url(:medium), class: "recipe_image"
    .col-md-8
      #recipe_info
        %h1= @recipe.title
        %p.description= @recipe.description
    
  .row
    .col-md-6
      #ingredients
        %h2 Ingredients
        %ul
          - @recipe.ingredients.each do |ingredient|
            %li= ingredient.name
    .col-md-6
      #directions
        %h2 Directions
        %ul
          - @recipe.directions.each do |direction|
            %li= direction.step

  .row
    .col-md-12
      = link_to "Back", root_path, class: "btn btn-default"
      = link_to "Edit", edit_recipe_path, class: "btn btn-default"
      = link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>Ingredients와 Directions가 존재하면 삭제 시 500 Error가 발생한다.    
- 2020-10-26
>devise를 설치하기 위해 Gemfile에 다음을 추가하고 설치합니다.
``` gemfile
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo gem install devise
$ sudo rails generate devise:install
```
>devise를 사용하기 위해 config/environments/development.rb 파일에 다음을 추가합니다.    
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>views를 생성해줍니다.    
>User를 생성해줍니다.    
>마이그레이션을 해줍니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>app/models/user.rb 파일에 다음을 추가합니다.    
>app/models/recipe.rb 파일에 다음을 추가합니다.    
``` rb
has_many :recipes
```
``` rb
belongs_to :user
```
>app/controllers/recipes_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
# 생략
def new
  @recipe = Recipe.new
end
def create
  @recipe = Recipe.new(recipe_params)
# 이하 생략
# after
# 생략
def new
  @recipe = current_user.recipes.build
end
def create
  @recipe = current_user.recipes.build(recipe_params)
# 이하 생략
```
>레일즈 콘솔에서 다음과 같이 레시피를 생성하고 유저를 추가합니다.
``` terminal
$ sudo rails c
$ @recipe = Recipe.new
$ @recipe = current_user.recipes.build
```
>app/views/recipre/show.html.haml 파일에 다음을 추가합니다.
``` haml
<!-- 생략 -->
%p
  Submitted by
  = @recipe.user.email
<!-- 이하 생략 -->
```
>app/views/layouts/application.html.haml 파일을 다음과 같이 수정해줍니다.
``` haml
<!-- before -->
<!-- 생략 -->
%ul.nav.navbar-nav.navbar-right
  %li= link_to "New Recipe", new_recipe_path
  %li= link_to "Sign Out", root_path
<!-- 이하 생략 -->
<!-- after -->
<!-- 생략 -->
- if user_signed_in?
  %ul.nav.navbar-nav.navbar-right
    %li= link_to "New Recipe", new_recipe_path
    %li= link_to "Sign Out", destroy_user_session_path, method: :delete
- else
  %ul.nav.navbar-nav.navbar-right
    %li= link_to "Sign Up", new_user_registration_path
    %li= link_to "Sign in", new_user_session_path
<!-- 이하 생략 -->
```
>app/views/recipes/show.htrml.haml 파일을 다음과 같이 수정합니다.
``` haml
<!-- before -->
<!-- 생략 -->
= link_to "Edit", edit_recipe_path, class: "btn btn-default"
= link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
<!-- after -->
<!-- 생략 -->
- if user_signed_in?
  = link_to "Edit", edit_recipe_path, class: "btn btn-default"
  = link_to "Delete", recipe_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default"
```
>Sign in 페이지에 디자인을 입히기 위해 app/views/sessions/new.html.erb 파일을 다음과 같이 수정해줍니다.
``` erb
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <h2>Sign in</h2>

    <%= simple_form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
      <div class="form-inputs">
        <%= f.input :email,
                    required: false,
                    autofocus: true,
                    input_html: { class: 'form-control' } %>
        <%= f.input :password,
                    required: false,
                    input_html: { class: 'form-control' } %>
        <%= f.input :remember_me, as: :boolean, class: 'form-control' if devise_mapping.rememberable? %>
      </div>

      <div class="form-actions">
        <%= f.button :submit, "Sign in", class: 'btn btn-primary' %>
      </div>
      <br>
    <% end %>
    
    <%= render "devise/shared/links" %>
  </div>
</div>
```
>Sign Up 화면을 디자인하기 위해 app/views/devise/registrations/new.html.erb 파일을 다음과 같이 수정합니다.
``` erb
<div class="row">
  <div class="col-md-6 col-md-offset-3">
    <h2>Sign up</h2>

    <%= simple_form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
      <%= f.error_notification %>

      <div class="form-inputs">
        <%= f.input :email,
                    required: true,
                    autofocus: true,
                    input_html: { class: 'form-control' }%>
        <%= f.input :password,
                    required: true,
                    hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length),
                    input_html: { class: 'form-control' } %>
        <%= f.input :password_confirmation,
                    required: true,
                    input_html: { class: 'form-control' } %>
      </div>
      <br>
      <div class="form-actions">
        <%= f.button :submit, "Sign up", class: "btn btn-primary" %>
      </div>
      <br>
    <% end %>

    <%= render "devise/shared/links" %>
  </div>
</div>
```
---

## Pinterest Clone
- 2020-10-28
>레일즈 프로젝트를 생성합니다.
``` terminal
$ sudo rails new pinterestclone
```
>프로젝트 폴더로 이동합니다.    
>레일즈 서버를 시작해줍니다.    
``` terminal
$ cd pinterestclone
$ sudo rails server
```
>haml, bootstrap-sass, simple_form을 설치하기 위해 Gemfile에 다음을 추가하고 설치합니다.
``` gemfile
gem 'haml', '~> 5.2'
gem 'bootstrap-sass', '~> 3.4', '>= 3.4.1'
gem 'simple_form', '~> 5.0', '>= 5.0.3'
```
``` terminal
$ sudo gem install haml
$ sudo gem install bootstrap-sass
$ sudo gem install simple_form
```
>Pin 모델을 생성하고 마이그레이션 한 뒤 컨트롤러를 생성해줍니다.
``` terminal
$ sudo rails generate model Pin title:string description:text
$ sudo rake db:migrate
$ sudo rails generate controller Pins
```
>app/controllers/pins_controller.rb 파일에 index 메소드를 생성합니다.
``` rb
def index
end
```
>config/routes.rb 파일에 경로를 설정해줍니다.
``` rb
resources :pins

root "pins#index"
```
>index 화면을 추가하기 위해 app/views/pins 폴더에 index.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
%h1 This is the index placeholder
```
>잘 동작하는지 확인한 뒤, pin 생성을 위해 app/controllers/pins_controller.rb 파일에 다음을 추가합니다.
``` rb
before_action :find_pin, only: [:show, :edit, :update, :destroy]
# 중략
def show
end
def new
  @pin = Pin.new
end
def create
  @pin = Pin.new(pin_params)

  if @pin.save
    redirect_to @pin, notice: "Successfully created new Pin"
  else
    render 'new'
  end
end

private

def pin_params
  params.require(:pin).permit(:title, :description)
end
def find_pin
  @pin = Pin.find(params[:id])
end
```
>pin을 생성하기 위해 app/views/pins/new.html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
%h1 New Form

= render 'form'

= link_to "Back", root_path
```
>simple_form을 쉽게 사용하기 위해 터미널에서 다음을 설치해줍니다.
``` terminal
$ sudo rails generate simple_form:install --bootstrap
```
>pin을 보기 위한 form을 위해 app/view/pins/_form/html.haml 파일을 생성하고 다음을 추가해줍니다.
``` haml
= simple_form_for @pin, html: { multipart: true } do |f|
  - if @pin.errors.any?
    #errors
      %h2
      = pluralize(@pin.errors.count, "error")
      prevented this Pin from saving
      %ul
        - @pin.errors.full_messages.each do |msg|
          %li= msg
  
  .form-group
    = f.input :title, input_html: { class: 'form-control' }

  .form-group
    = f.input :description, input_html: { class: 'form-control' }

  = f.button :submit, class: "btn btn-primary"
```
>app/views/layouts/application.html.erb 파일을 application.html.haml 파일로 바꾸고 다음과 같이 수정합니다.
``` haml
!!! 5
%html
%head
  %title Pin Board
  = csrf_meta_tags
  = csp_meta_tag

  = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
  = javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'

%body
  - flash.each do |name, msg|
    = content_tag :div, msg, class: "alert alert-info"

  = yield
```
>생성한 pin을 보기 위해 app/views/pins 폴더에 show.html.haml 파일을 만들고 다음을 추가해줍니다.
``` haml
%h1= @pin.title
%p= @pin.description

= link_to "Back", root_path
```
>index 화면에서 pin으로 이동할 수 있게 하기 위해 app/views/pins/index.html.haml 파일을 다음과 같이 수정합니다.    
>app/controllers/pins_controller.rb 파일도 다음과 같이 수정합니다.
``` haml
- @pins.each do |pin|
  %h2= link_to pin.title, pin
```
``` rb
# before
def index
end
# after
def index
  @pins = Pin.all.order("created_at DESC")
end
```
- 2020-10-30
>app/controllers/pins_controller.rb 파일에 다음을 추가해줍니다.
``` rb
def edit
end
def update
  if @pin.update(pin_params)
    redirect_to @pin, notice: "Pin was Successfully updated!!"
  else
    render 'edit'
  end
end
def destroy
end
```
>app/views/pins/edit.html.haml 파일을 생성하고 다음을 추가해줍니다.    
>app/views/pins/show.html.haml 파일에 다음을 추가해줍니다.
``` haml
%h1 Edit Pin

= render 'form'

= link_to "Cancle", pin_path
```
``` haml
= link_to "Edit", edit_pin_path
```
>app/controllers/pins_controller.rb 파일을 다음과 같이 수정합니다.    
>app/views/pins/show.html.haml 파일에 다음을 추가해줍니다.
``` rb
# before
def destroy
end
# after
def destroy
  @pin.destroy
  redirect_to root_path
end
```
``` haml
= link_to "Delete", pin_path, method: :delete, data: { confirm: 'Are you sure?' }
```
>app/views/pins/index.html.haml 파일 최상단에 다음을 추가해줍니다.
``` haml
=link_to "New Pin", new_pin_path
```
- 2020-10-31
>User를 추가하기 위해 Gemfile에 다음을 추가하고 설치해줍니다.
``` gemfile
gem 'devise', '~> 4.7', '>= 4.7.3'
```
``` terminal
$ sudo gem install devise
$ sudo rails generate devise:install
```
>config/environments/development.rb 파일에 다음을 추가합니다.
``` rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
>views와 User 모델을 만들고 마이그레이션합니다.
``` terminal
$ sudo rails generate devise:views
$ sudo rails generate devise User
$ sudo rake db:migrate
```
>app/models/user.rb 파일에 다음을 추가합니다.    
>app/models/pin.rb 파일에 다음을 추가합니다.
``` rb
has_many :pins
```
``` rb
belongs_to :user
```
>User를 Pins에 마이그레이션해줍니다.
``` terminal
$ sudo rails generate migration add_user_id_to_pins user_id:integer:index
$ sudo rake db:migrate
```
>레일즈 콘솔에 들어가서 pin 게시물에 user를 추가해줍니다.
``` terminal
$ sudo rails c
$ @pin = Pin.first
$ @user = User.first
$ @pin.user = @user
$ @pin
  =>Pin id: 2, title: "This is my first Pin,(Edit)", description: "I'm baby iPhone XOXO williamsburg pok pok twee qui...", created_at: "2020-10-28 12:42:52", updated_at: "2020-10-30 12:04:18", user_id: 1
$ @pin.save
```
>pin 게시물의 작성자 표시를 위해 app/views/pins/show.html.haml 파일에 다음을 추가합니다.
``` haml
%p
Submitted by 
=@pin.user.email

%br
```
>pin 게시물 생성 시에 작성자를 함께 넣기 위해 app/controllers/pins_controller.rb 파일을 다음과 같이 수정합니다.
``` rb
# before
  @pin = Pin.new
end
def create
  @pin = Pin.new(pin_params)
# after
  @pin = current_user.pins.build
end
def create
  @pin = current_user.pins.build(pin_params)
```
- 2020-11-01
>스타일을 설정하기위해 app/assets/stylesheets/application.css 파일을 application.scss 파일로 변경하고 다음을 추가합니다.
``` scss
@import "bootstrap-sprockets";
@import "bootstrap";
```
>Gemfile에 jQuery를 추가하고 설치해줍니다.
``` gemfile
gem 'jquery-rails'
```
``` terminal
$ sudo bundle install
```
>app/javascript/packs/application.js 파일에 다음을 추가합니다.
``` js
require("jquery")
require("bootstrap-sprockets")
```
>app/views/layouts/application.html.haml 파일을 다음과같이 수정합니다.
``` haml
<!-- before -->
%body 
  - flash.each do |name, msg|
    = content_tag :div, msg, class: "alert alert-info"
    
  = yield
<!-- after -->
%body
  %nav.navbar.navbar-default
    .container
      .navbar-brand= link_to "Pin Board", root_path

      - if user_signed_in?
        %ul.nav.navbar-nav.navbar-right
          %li= link_to "New Pin", new_pin_path
          %li= link_to "Account", edit_user_registration_path
          %li= link_to "Sign Out", destroy_user_session_path, method: :delete
      - else
        %ul.nav.navbar-nav.navbar-right
          %li= link_to "Sign Up", new_user_registration_path
          %li= link_to "Sign In", new_user_session_path
  .container
    - flash.each do |name, msg|
      = content_tag :div, msg, class: "alert alert-info"
    
    = yield
```
>New Pin이 중복되는 것을 방지하기 위해 app/views/pins/index.html.haml 파일에서 다음을 삭제합니다.
``` haml
=link_to "New Pin", new_pin_path
```
>app/views/pins/new.html.haml 파일에 스타일을 적용시켜 줍니다.    
>app/views/pins/edit.html.haml 파일에 스타일을 적용시켜 줍니다.
``` haml
.col-md-6.col-md-offset-3
  %h1 New Form
  = render 'form'
  = link_to "Back", root_path
```
``` haml
.col-md-6.col-md-offset-3
  %h1 Edit Pin
  = render 'form'
  = link_to "Cancle", pin_path
```