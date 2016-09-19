module ProjectSupervisor

  include Ecolo

end

module ProjectOne

  include Ecolo

  env_with delegate: ProjectSupervisor

end

module ProjectTwo

  include Ecolo

  env_with delegate: ProjectSupervisor

end

module ProjectThree

  include Ecolo

  env_with ProjectSupervisor

end

module ProjectFour

  include Ecolo

  env_with 'PROJECT_FOUR_ALTERNATE_ENV'

end

module ProjectFive

  include Ecolo

end

class ProjectClassOne

  include Ecolo

end

class ProjectClassTwo

  include Ecolo

  env_with delegate: ProjectSupervisor

end

ENV['PROJECT_SUPERVISOR_ENV'] = 'supervisor_env'
ENV['PROJECT_FOUR_ALTERNATE_ENV'] = 'alternate_env'
ENV['PROJECT_CLASS_ONE_ENV'] = 'project_class_env'

describe Ecolo do
  describe ProjectSupervisor do
    it "should have getter for env" do
      expect(described_class.env).to eq 'supervisor_env'
    end

    it "should have setter for env" do
      expect(described_class.env = 'new_env').to eq 'new_env'
    end

    after {
      described_class.env_with
    }
  end

  describe ProjectOne do
    it "should have getter for env" do
      expect(described_class.env).to eq 'supervisor_env'
    end

    it "should have setter for env" do
      expect(described_class.env = 'new_env').to eq 'new_env'
    end

    it "should use delegate setter" do
      ProjectSupervisor.env = 'new_supervisor_env'
      expect(ProjectOne.env).to eq 'new_supervisor_env'
      expect(ProjectTwo.env).to eq 'new_supervisor_env'
    end

    after {
      ProjectSupervisor.env_with
    }
  end

  describe ProjectThree do
    it "should have getter for env" do
      expect(described_class.env).to eq 'supervisor_env'
    end

    it "should have setter for env using Supervisor env variable but not setter" do
      expect(described_class.env = 'new_three_env').to eq 'new_three_env'
      expect(ProjectSupervisor.env).to eq 'supervisor_env'
    end

    after {
      described_class.env_with ProjectSupervisor
    }
  end

  describe ProjectFour do
    it "should have getter for env" do
      expect(described_class.env).to eq 'alternate_env'
    end

    it "should have setter for env" do
      expect(described_class.env = 'test').to eq 'test'
    end

    after {
      described_class.env_with 'PROJECT_FOUR_ALTERNATE_ENV'
    }
  end

  describe ProjectFive do
    it "should have getter for env" do
      expect(described_class.env).to eq 'development'
    end

    it "should have setter for env" do
      expect(described_class.env = 'production').to eq 'production'
    end

    after {
      described_class.env_with
    }
  end

  describe ProjectClassOne do
    it "should have getter for env" do
      described_class.env_with
      expect(described_class.env).to eq 'project_class_env'
    end

    it "should have getter for env with string" do
      described_class.env_with 'PROJECT_FOUR_ALTERNATE_ENV'
      expect(described_class.env).to eq 'alternate_env'
    end

    it "should have getter for env with constant" do
      described_class.env_with ProjectSupervisor
      expect(described_class.env).to eq 'supervisor_env'

      described_class.env = 'foo_bar_env'
      expect(ProjectSupervisor.env).to eq 'supervisor_env'
    end

    it "should have setter for env" do
      expect(described_class.env = 'new_project_class_env').to eq 'new_project_class_env'
    end
  end

  describe ProjectClassTwo do
    it "should have getter for env" do
      expect(described_class.env).to eq 'supervisor_env'
    end

    it "should have setter for env borrowed from delegate" do
      ProjectSupervisor.env = 'all_projects_env'
      expect(described_class.env).to eq 'all_projects_env'
    end

    it "should be able to alter its way to fetvh env" do
      described_class.env_with ProjectClassOne
      expect(described_class.env).to eq 'project_class_env'
    end

    after {
      ProjectSupervisor.env_with
      ProjectClassTwo.env_with delegate: ProjectSupervisor
    }
  end
end
