defmodule Poc.FileController do
  use Poc.Web, :controller

  alias Poc.UploadAgent

  plug :scrub_params, "file" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"file" => file}) do
    upload = file["archive"]
    title = file["title"]
    filename = "archives/#{upload.filename}"

    :ok = File.cp(upload.path, filename)
    {:ok, files} = :zip.unzip(to_char_list(filename), [{:cwd, 'archives'}])

    pjdl_filename =
      files
      |> Enum.map(&(to_string(&1)))
      |> Enum.find(fn filename -> pjdl_file?(filename) end)

    UploadAgent.add_upload("#{title} - #{pjdl_filename}")
    Poc.Endpoint.broadcast("uploads:lobby", "new:upload", %{
          filename: pjdl_filename,
          title: title
    })

    MyApp.main([pjdl_filename])

    conn
    |> put_flash(:info, "File uploaded")
    |> redirect(to: file_path(conn, :new))
  end

  defp pjdl_file?(filename) do
    Regex.match?(~r/\Aarchives\/\w+.pjdl\z/, filename)
  end
end
