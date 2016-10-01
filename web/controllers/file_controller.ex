defmodule Poc.FileController do
  use Poc.Web, :controller

  alias Poc.JobTemplateAgent

  plug :scrub_params, "file" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"file" => file}) do
    upload = file["archive"]
    filename = "archives/#{upload.filename}"

    :ok = File.cp(upload.path, filename)
    {:ok, files} = :zip.unzip(to_char_list(filename), [{:cwd, 'archives'}])

    pjdl_filename =
      files
      |> Enum.map(&(to_string(&1)))
      |> Enum.find(fn filename -> pjdl_file?(filename) end)

    MyApp.main([pjdl_filename])
    job_template = MyApp.parse(pjdl_filename)

    case JobTemplateAgent.add_template(job_template) do
      {:ok, template} ->
        Poc.Endpoint.broadcast("uploads:lobby", "new:upload", %{
              id: template.id,
              description: template.short_description,
              results_visibility: template.results_visibility,
              instantiation: template.instantiation
        })

        conn
        |> put_flash(:info, "File uploaded")
        |> redirect(to: upload_path(conn, :index))
      {:error, :alread_uploaded} ->
        conn
        |> put_flash(:error, "Job template with this id is already uploaded")
        |> redirect(to: file_path(conn, :new))
    end


  end

  defp pjdl_file?(filename) do
    Regex.match?(~r/\Aarchives\/\w+.pjdl\z/, filename)
  end
end
