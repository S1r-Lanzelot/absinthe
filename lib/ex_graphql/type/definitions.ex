defmodule ExGraphQL.Type.Definitions do

  alias ExGraphQL.Type

  defmacro fields(definitions) do
    quote do
      fn ->
        named(ExGraphQL.Type.FieldDefinition, unquote(definitions))
      end
    end
  end

  @doc """
  Deprecate a field or argument with an optional reason
  """
  @spec deprecate(Keyword.t) :: Keyword.t
  @spec deprecate(Keyword.t, Keyword.t) :: Keyword.t
  def deprecate(node, options \\ []) do
    node
    |> Keyword.put(:deprecation, struct(Type.Deprecation, options))
  end

  def non_null(type) do
    %Type.NonNull{of_type: type}
  end

  def list_of(type) do
    %Type.List{of_type: type}
  end

  def args(definitions) do
    named(ExGraphQL.Type.Argument, definitions)
  end

  def named(mod, definitions) do
    definitions
    |> Enum.into(%{}, fn ({identifier, definition}) ->
      {
        identifier,
        struct(mod, [{:name, identifier |> to_string} | definition])
      }
    end)
  end

end