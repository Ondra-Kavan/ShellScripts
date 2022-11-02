git clone https://github.com/helix-editor/helix /tmp/helix
cd /tmp/helix
cargo install --path helix-term

mkdir ~/.config/helix
cp runtime ~/.config/helix/runtime -r
echo export PATH="$HOME/.cargo/bin:$PATH" >> ~/.bashrc
