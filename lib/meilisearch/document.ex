defmodule Meilisearch.Document do
  @moduledoc """
  Collection of functions used to manage documents.

  [MeiliSearch Documentation - Documents](https://docs.meilisearch.com/references/documents.html)
  """

  alias Meilisearch.HTTP

  @doc """
  Get one document by id.

  ## Example

      iex> Meilisearch.Document.get("meilisearch_test", 1)
      {:ok,
      %{
        "id" => 1,
        "tagline" => "In space no one can hear you scream",
        "title" => "Alien"
      }}
  """
  @spec get(String.t(), String.t()) :: HTTP.response()
  def get(index_uid, document_id) do
    HTTP.get_request("indexes/#{index_uid}/documents/#{document_id}")
  end

  @doc """
  List documents in given index.

  ## Options

    * `offset` 	Number of documents to skip.  Defaults to `0`
    * `limit` 	Maximum number of documents returned.  Defaults to `20`

  ## Examples

      iex> Meilisearch.Document.list("meilisearch_test")
      {:ok,
        [
          %{
            "id" => 2,
            "tagline" => "You'll never go in the water again",
            "title" => "Jaws"
          },
          %{
            "id" => 1,
            "tagline" => "In space no one can hear you scream",
            "title" => "Alien"
          }
        ]
      }

      iex> Meilisearch.Document.get("meilisearch_test", limit: 2, offset: 4)
      {:ok,
        [
          %{
            "id" => 6,
            "tagline" => "Who ya gonna call?",
            "title" => "Ghostbusters"
          },
          %{
            "id" => 5,
            "tagline" => "Be Afraid. Be very afraid.",
            "title" => "The Fly"
          }
        ]
      }
  """
  @spec list(String.t(), Keyword.t()) :: HTTP.response()
  def list(index_uid, opts \\ []) do
    HTTP.get_request("indexes/#{index_uid}/documents", [], params: opts)
  end

  @doc """
  Add document(s) to given index.

  If an exisiting document (based on primary key) is given it will be replaced.

  ## Examples

      iex> Meilisearch.Document.add_or_replace("meilisearch_test", %{
        "id" => 2,
        "tagline" => "You'll never go in the water again",
        "title" => "Jaws"
      })
      {:ok, %{"updateId" => 1}}

      iex> Meilisearch.Document.add_or_replace(
        "meilisearch_test",
        [
          %{
            "id" => 6,
            "tagline" => "Who ya gonna call?",
            "title" => "Ghostbusters"
          },
          %{
            "id" => 5,
            "tagline" => "Be Afraid. Be very afraid.",
            "title" => "The Fly"
          }
        ]
      )
      {:ok, %{"updateId" => 1}}
  """

  @spec add_or_replace(String.t(), list(any), Keyword.t()) :: HTTP.response()
  def add_or_replace(index_uid, docs, opts \\ [])

  def add_or_replace(index_uid, doc, opts) when not is_list(doc) do
    add_or_replace(index_uid, [doc], opts)
  end

  def add_or_replace(index_uid, docs, opts) do
    HTTP.post_request("indexes/#{index_uid}/documents", docs, [], params: opts)
  end

  @doc """
  Add document(s) to given index.

  If an exisiting document (based on primary key) is given it will be updated with provided values.

  ## Examples

      iex> Meilisearch.Document.add_or_update("meilisearch_test", %{
        "id" => 2,
        "tagline" => "You'll never go in the water again",
        "title" => "Jaws"
      })
      {:ok, %{"updateId" => 1}}

      iex> Meilisearch.Document.add_or_update(
        "meilisearch_test",
        [
          %{
            "id" => 6,
            "tagline" => "Who ya gonna call?",
            "title" => "Ghostbusters"
          },
          %{
            "id" => 5,
            "tagline" => "Be Afraid. Be very afraid.",
            "title" => "The Fly"
          }
        ]
      )
      {:ok, %{"updateId" => 1}}
  """
  @spec add_or_update(String.t(), list(any), Keyword.t()) :: {:ok, any} | {:error, String.t()}
  def add_or_update(index_uid, docs, opts \\ [])

  def add_or_update(index_uid, doc, opts) when not is_list(doc) do
    add_or_update(index_uid, [doc], opts)
  end

  def add_or_update(index_uid, docs, opts) do
    HTTP.put_request("indexes/#{index_uid}/documents", docs, [], params: opts)
  end

  @doc """
  Delete one or more documents based on id in a given index.

  ## Example

      iex> Meilisearch.Document.delete("meilisearch_test", 1)
      {:ok, %{"updateId" => 0}}

      iex> Meilisearch.Document.delete("meilisearch_test", [1,2,3,4])
      {:ok, %{"updateId" => 0}}
  """

  @spec delete(String.t(), String.t() | list(String.t())) :: {:ok, any} | {:error, String.t()}
  def delete(index_uid, document_ids) when is_list(document_ids) do
    HTTP.post_request("indexes/#{index_uid}/documents/delete-batch", document_ids)
  end

  def delete(index_uid, document_id) do
    HTTP.delete_request("indexes/#{index_uid}/documents/#{document_id}")
  end

  @doc """
  Delete all documents in given index.

  ## Example

      iex> Meilisearch.Document.delete_all("meilisearch_test")
      {:ok, %{"updateId" => 0}}

  """
  @spec delete_all(String.t()) :: {:ok, any} | {:error, binary}
  def delete_all(index_uid) do
    HTTP.delete_request("indexes/#{index_uid}/documents")
  end
end
