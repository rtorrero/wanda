defmodule Wanda.Executions.FakeEvaluationTest do
  use ExUnit.Case

  import Wanda.Factory

  alias Wanda.Catalog.{
    Check,
    Fact,
    Value
  }

  alias Wanda.Executions.{
    CheckResult,
    Execution,
    FakeEvaluation,
    Result
  }

  describe "complete_fake_execution/4" do
    test "should complete a running fake execution" do
      [
        %Fact{
          name: fact_name_1
        },
        %Fact{
          name: fact_name_2
        }
      ] = catalog_facts = build_list(2, :catalog_fact)

      [
        %Value{
          name: value_name_1
        },
        %Value{
          name: value_name_2
        }
      ] = values = build_list(2, :catalog_value)

      [
        %Check{
          id: check_id_1
        },
        %Check{
          id: check_id_2
        }
      ] = checks = build_list(2, :check, facts: catalog_facts, values: values)

      [
        %Execution.Target{
          agent_id: agent_id
        }
      ] = build_list(1, :execution_target, checks: [check_id_1, check_id_2])

      targets = build_list(1, :target, agent_id: agent_id, checks: [check_id_1, check_id_2])

      %Execution{
        execution_id: execution_id,
        group_id: group_id
      } = build(:execution, status: :running)

      assert %Result{
               execution_id: ^execution_id,
               group_id: ^group_id,
               check_results: [
                 %CheckResult{
                   check_id: ^check_id_1,
                   agents_check_results: [
                     %Wanda.Executions.AgentCheckResult{
                       agent_id: ^agent_id,
                       facts: [
                         %Wanda.Executions.Fact{
                           name: ^fact_name_1,
                           check_id: ^check_id_1
                         },
                         %Wanda.Executions.Fact{
                           name: ^fact_name_2,
                           check_id: ^check_id_1
                         }
                       ],
                       values: [
                         %{
                           name: ^value_name_1
                         },
                         %{
                           name: ^value_name_2
                         }
                       ]
                     }
                   ]
                 },
                 %CheckResult{
                   check_id: ^check_id_2,
                   agents_check_results: [
                     %Wanda.Executions.AgentCheckResult{
                       agent_id: ^agent_id,
                       facts: [
                         %Wanda.Executions.Fact{
                           name: ^fact_name_1,
                           check_id: ^check_id_2
                         },
                         %Wanda.Executions.Fact{
                           name: ^fact_name_2,
                           check_id: ^check_id_2
                         }
                       ],
                       values: [
                         %{
                           name: ^value_name_1
                         },
                         %{
                           name: ^value_name_2
                         }
                       ]
                     }
                   ]
                 }
               ]
             } =
               FakeEvaluation.complete_fake_execution(
                 execution_id,
                 group_id,
                 targets,
                 checks
               )
    end
  end
end
