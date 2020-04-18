import PathKit

class ScaffoldRunner {

    func run() {
        let originPath = Path("/usr/local/share/dazzle/Templates")
        let destinationPath = Path.current + Path("Templates")

        guard !destinationPath.exists else {
            print("Templates folder already exist in your current project.")
            return
        }

        do {
            try originPath.copy(destinationPath)
        } catch {
            print("Can't copy template files.")
        }
    }
}
