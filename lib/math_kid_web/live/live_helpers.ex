defmodule MathKidWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `MathKidWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal MathKidWeb.AddSubLive.FormComponent,
        id: @add_sub.id || :new,
        action: @live_action,
        add_sub: @add_sub,
        return_to: Routes.add_sub_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(MathKidWeb.ModalComponent, modal_opts)
  end
end
