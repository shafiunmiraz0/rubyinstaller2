require "base_task"

class ArchiveTask < BaseTask
  def initialize(*args)
    super
    sandboxdir = sandbox_task.sandboxdir
    self.archivefile = "archive/rubyinstaller-#{package.rubyver_pkgrel}-#{package.arch}.7z"

    desc "7z archive for ruby-#{package.rubyver}-#{package.arch}"
    task "archive" => [:devkit, "sandbox", archivefile]

    file archivefile => sandbox_task.sandboxfiles do
      rm_f archivefile
      msys_sh <<-EOT
        pacman -S --needed --noconfirm p7zip
      EOT

      chdir "sandbox" do
        sh "sh 7z a -bd ../#{archivefile} #{sandboxdir.gsub("sandbox/", "")} | ruby -ne \"STDERR.print '.'\""
      end
    end
  end
end
