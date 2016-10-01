defmodule Poc.Router do
  use Poc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Poc do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/file", FileController, :new
    post "/file", FileController, :create

    get "/uploads", UploadController, :index
    resources "/uploads", UploadController, only: [:index, :delete, :edit, :update]


    get "/templates", TemplateController, :new
    post "/templates", TemplateController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", Poc do
  #   pipe_through :api
  # end
end
