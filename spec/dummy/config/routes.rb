# frozen_string_literal: true

Rails.application.routes.draw do
  mount Blazar2::Engine => '/blazar2'
end
